import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/repositories/auth_repository.dart';
import 'package:mingle_talk_agent/presentation/controllers/auth_controller.dart';
import 'package:pusher_reverb_flutter/pusher_reverb_flutter.dart';

import '../../data/models/call.dart';
import '../config/app_config.dart';
import 'alert_notification_service.dart';

class WebSocketService extends GetxService with WidgetsBindingObserver {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() => _instance;

  WebSocketService._internal();

  ReverbClient? _client;
  int? _agentId;
  bool _isConnected = false;
  Channel? _agentChannel;
  StreamSubscription<ConnectionState>? _connectionStateSubscription;

  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const int _reconnectDelaySeconds = 5;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<void> init() async {
    try {
      final user = Get.find<AuthController>().user.value;
      if (user.id == 0) {
        debugPrint('WebSocket: No user found in local storage');
        return;
      }
      _agentId = user.id;
      await _setupConnectivityListener();
      await _connect();
    } catch (e) {
      debugPrint('WebSocket: Failed to initialize - $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('WebSocket: App Resumed, triggering reconnect');
      onAppResume();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      debugPrint('WebSocket: App Backgrounded, disconnecting proactively');
      _client?.disconnect();
      _isConnected = false;
    }
  }

  Future<void> _connect() async {
    if (_agentId == null) return;

    try {
      _client = ReverbClient.instance(
        host: AppConfig.websocketHost,
        port: AppConfig.websocketPort,
        appKey: AppConfig.websocketKey,
        useTLS: true,
        pingInterval: Duration(seconds: 20),
        authEndpoint:
            '${AppConfig.apiBaseUrl}${AppConfig.websocketAuthEndpoint}',
        authorizer: (channelName, socketId) async {
          final t = await Get.find<AuthRepository>().getAccessToken();
          if (t.isEmpty) {
            debugPrint('WebSocket: Auth token empty for auth request');
            debugPrint('TODO: Add token refresh logic here');
          }
          return {'Authorization': 'Bearer $t', 'Accept': 'application/json'};
        },
        onConnecting: () {
          debugPrint('WebSocket: Connecting...');
          _isConnected = false;
        },
        onConnected: (socketId) {
          debugPrint('WebSocket: Connected successfully (socket: $socketId)');
          _isConnected = true;
          _reconnectAttempts = 0;
          _subscribeToAgentChannel();
        },
        onReconnecting: () {
          debugPrint('WebSocket: Reconnecting...');
          _isConnected = false;
        },
        onDisconnected: () {
          debugPrint('WebSocket: Disconnected');
          _isConnected = false;
          _agentChannel = null;
          _handleDisconnect();
        },
        onError: (error) {
          debugPrint('WebSocket: Error - $error');
          _handleDisconnect();
        },
      );

      await _client!.connect();
    } catch (e) {
      debugPrint('WebSocket: Initial connection failed - $e');
      if (e.toString().contains('403') ||
          e.toString().contains('unauthorized')) {
        debugPrint('WebSocket: Auth failed, token may be expired');
        debugPrint('TODO: Add token refresh logic here');
      }
      _handleDisconnect();
    }
  }

  Future<void> _subscribeToAgentChannel() async {
    if (_client == null || _agentId == null || !_isConnected) {
      debugPrint('WebSocket: Cannot subscribe - not connected');
      return;
    }
    try {
      _agentChannel = _client!.subscribeToPrivateChannel(
        'private-agent.$_agentId',
      );
      _agentChannel!.bind('call.notification', (eventName, data) {
        debugPrint('WebSocket: data: $data');
        if (data != null) {
          try {
            Map<String, dynamic> jsonData;
            if (data is String) {
              jsonData = jsonDecode(data);
            } else if (data is Map<String, dynamic>) {
              jsonData = data;
            } else {
              debugPrint(
                'WebSocket: Unexpected data type: ${data.runtimeType}',
              );
              return;
            }
            final alert = AlertNotification.fromMap(jsonData);
            // Use centralized handler in AlertNotificationService
            AlertNotificationService().handleAlertNotification(alert);
          } catch (e) {
            debugPrint('WebSocket: Failed to parse notification: $e');
          }
        }
      });
      debugPrint('WebSocket: Connected successfully and subscribed');
    } catch (e) {
      debugPrint('WebSocket: Subscription failed - $e');
    }
  }

  void _handleDisconnect() {
    if (_isReconnecting || _reconnectAttempts >= _maxReconnectAttempts) return;

    _isReconnecting = true;
    _reconnectAttempts++;
    debugPrint(
      'WebSocket: Reconnecting ($_reconnectAttempts/$_maxReconnectAttempts)',
    );
    Future.delayed(Duration(seconds: _reconnectDelaySeconds), () {
      _isReconnecting = false;
      _reconnect();
    });
  }

  Future<void> _reconnect() async {
    try {
      final user = Get.find<AuthController>().user.value;
      if (user.id != 0) {
        _client?.disconnect();
        _client = null;
        await _connect();
      }
    } catch (e) {
      debugPrint('WebSocket: Reconnect failed - $e');
    }
  }

  Future<void> _setupConnectivityListener() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      if (!result.contains(ConnectivityResult.none) && !_isConnected) {
        debugPrint('WebSocket: Network recovered, reconnecting...');
        _reconnect();
      }
    });
  }

  void onAppResume() => _reconnect();

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _agentChannel?.unsubscribe();
    _client?.disconnect();
    _client = null;
    _agentChannel = null;
    _agentId = null;
    _isConnected = false;
    _reconnectAttempts = 0;
    _isReconnecting = false;
  }
}
