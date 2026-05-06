import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/repositories/auth_repository.dart';
import 'package:mingle_talk_agent/presentation/controllers/auth_controller.dart';
import 'package:pusher_reverb_flutter/pusher_reverb_flutter.dart';

import '../../data/models/call.dart';
import '../config/app_config.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  ReverbClient? _client;
  int? _agentId;

  final StreamController<AlertNotification> _alertNotificationController =
      StreamController<AlertNotification>.broadcast();
  Stream<AlertNotification> get alertNotificationStream =>
      _alertNotificationController.stream;

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

  Future<void> _connect() async {
    if (_agentId == null) return;

    try {
      _client = ReverbClient.instance(
        host: AppConfig.websocketHost,
        port: AppConfig.websocketPort,
        appKey: AppConfig.websocketKey,
        authEndpoint: '${AppConfig.baseUrl}${AppConfig.websocketAuthEndpoint}',
        authorizer: (channelName, socketId) async {
          final t = await Get.find<AuthRepository>().getAccessToken();
          if (t.isEmpty) {
            debugPrint('WebSocket: Auth token empty for auth request');
            debugPrint('TODO: Add token refresh logic here');
          }
          return {
            'Authorization': 'Bearer $t',
            'Accept': 'application/json',
          };
        },
      );

      await _subscribeToAgentChannel();
      await _client!.connect();
      _reconnectAttempts = 0;
      debugPrint('WebSocket: Connected successfully');
    } catch (e) {
      debugPrint('WebSocket: Connection failed: $e');
      if (e.toString().contains('403') ||
          e.toString().contains('unauthorized')) {
        debugPrint('WebSocket: Auth failed, token may be expired');
        debugPrint('TODO: Add token refresh logic here');
      }
      _handleDisconnect();
    }
  }

  Future<void> _subscribeToAgentChannel() async {
    if (_client == null || _agentId == null) return;

    final channel =
        _client!.subscribeToPrivateChannel('private-agent.$_agentId');

    channel.bind('call.notification', (eventName, data) {
      debugPrint('WebSocket: data: $data');
      if (data != null) {
        try {
          final alert = AlertNotification.fromMap(data);
          _alertNotificationController.add(alert);
        } catch (e) {
          debugPrint('WebSocket: Failed to parse notification: $e');
        }
      }
    });
  }

  void _handleDisconnect() {
    if (_isReconnecting || _reconnectAttempts >= _maxReconnectAttempts) return;

    _isReconnecting = true;
    _reconnectAttempts++;
    debugPrint(
        'WebSocket: Reconnecting ($_reconnectAttempts/$_maxReconnectAttempts)');
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
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (!result.contains(ConnectivityResult.none)) {
        _reconnect();
      }
    });
  }

  void onAppResume() => _reconnect();

  void dispose() {
    _connectivitySubscription?.cancel();
    _client?.disconnect();
    _client = null;
    _alertNotificationController.close();
    _agentId = null;
    _reconnectAttempts = 0;
    _isReconnecting = false;
  }
}
