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
  Channel? _agentChannel;
  int? _agentId;

  // State Flags
  bool _isConnected = false;
  bool _isConnecting = false;
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
      debugPrint('WebSocket: App Resumed, checking connection');
      onAppResume();
    }
  }

  Future<void> _connect() async {
    if (_agentId == null) return;

    // STRICT GUARD: Prevent multiple connection attempts
    if (_isConnected || _isConnecting) {
      debugPrint(
        'WebSocket: Connection already active or in progress. Skipping.',
      );
      return;
    }

    _isConnecting = true;
    _isReconnecting = false; // Reset reconnect flag when a fresh connect starts

    try {
      _client = ReverbClient.instance(
        host: AppConfig.websocketHost,
        port: AppConfig.websocketPort,
        appKey: AppConfig.websocketKey,
        useTLS: true,
        pingInterval: const Duration(seconds: 20),
        authEndpoint:
            '${AppConfig.apiBaseUrl}${AppConfig.websocketAuthEndpoint}',
        authorizer: (channelName, socketId) async {
          final t = await Get.find<AuthRepository>().getAccessToken();
          if (t.isEmpty) {
            debugPrint('WebSocket: Auth token empty for auth request');
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
          _isConnecting = false;
          _reconnectAttempts = 0;
          _subscribeToAgentChannel();
        },
        onReconnecting: () {
          debugPrint('WebSocket: Reconnecting (Internal Reverb)...');
          _isConnected = false;
        },
        onDisconnected: () {
          debugPrint('WebSocket: Disconnected');
          _isConnected = false;
          _isConnecting = false;
          _agentChannel = null;
          _handleDisconnect();
        },
        onError: (error) {
          debugPrint('WebSocket: Error - $error');
          _isConnected = false;
          _isConnecting = false;
          _handleDisconnect();
        },
      );

      await _client!.connect();
    } catch (e) {
      _isConnecting = false;
      debugPrint('WebSocket: Initial connection failed - $e');
      if (e.toString().contains('403') ||
          e.toString().contains('unauthorized')) {
        debugPrint('WebSocket: Auth failed, token may be expired');
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
            AlertNotificationService().handleAlertNotification(alert);
          } catch (e) {
            debugPrint('WebSocket: Failed to parse notification: $e');
          }
        }
      });
      debugPrint(
        'WebSocket: Connected and subscribed to private-agent.$_agentId',
      );
    } catch (e) {
      debugPrint('WebSocket: Subscription failed - $e');
    }
  }

  void _handleDisconnect() {
    // Do not attempt to reconnect if already trying, max attempts reached, or app is in background
    if (_isReconnecting || _reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;
    debugPrint(
      'WebSocket: Triggering Reconnect ($_reconnectAttempts/$_maxReconnectAttempts) in $_reconnectDelaySeconds seconds',
    );

    Future.delayed(const Duration(seconds: _reconnectDelaySeconds), () {
      _isReconnecting = false;
      _reconnect();
    });
  }

  Future<void> _reconnect() async {
    // Double check before initiating reconnect
    if (_isConnected || _isConnecting) {
      debugPrint(
        'WebSocket: Already connected or connecting, skipping reconnect.',
      );
      return;
    }

    try {
      final user = Get.find<AuthController>().user.value;
      if (user.id != 0) {
        // IMPORTANT: Clean up old client before re-initializing
        _disconnectSafely();
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
      if (!result.contains(ConnectivityResult.none)) {
        if (!_isConnected && !_isConnecting && !_isReconnecting) {
          debugPrint('WebSocket: Network recovered, attempting reconnect...');
          _reconnect();
        }
      }
    });
  }

  void onAppResume() {
    if (!_isConnected && !_isConnecting) {
      debugPrint('WebSocket: App resumed and not connected, reconnecting...');
      _reconnectAttempts = 0; // Reset attempts on manual resume
      _reconnect();
    } else {
      debugPrint(
        'WebSocket: App resumed but connection is already active/processing.',
      );
    }
  }

  /// Safely unsubscribes and disconnects the existing client
  void _disconnectSafely() {
    runZonedGuarded(
      () {
        _agentChannel?.unsubscribe();
        _client?.disconnect();
      },
      (error, stack) {
        debugPrint('WebSocket: Ignored Exception during disconnect: $error');
      },
    );

    _client = null;
    _agentChannel = null;
    _isConnected = false;
    _isConnecting = false;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _disconnectSafely();
    _agentId = null;
    _reconnectAttempts = 0;
    _isReconnecting = false;
  }
}
