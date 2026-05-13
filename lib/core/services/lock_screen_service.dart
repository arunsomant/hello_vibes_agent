import 'dart:io';

import 'package:flutter/services.dart';

/// Service to dynamically control whether the app shows over the lock screen.
/// Only enable for calling screens, disable for all other screens.
class LockScreenService {
  static final LockScreenService _instance = LockScreenService._internal();
  factory LockScreenService() => _instance;
  LockScreenService._internal();

  static const _channel = MethodChannel('com.mingletalk.agent/lock_screen');

  bool _isEnabled = false;

  /// Enable showing the app over lock screen (for calling screens only)
  Future<void> enableShowOnLockScreen() async {
    if (_isEnabled) return;

    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('enableShowOnLockScreen');
        _isEnabled = true;
      } catch (e) {
        // Ignore errors - may happen if channel not ready
      }
    }
    // iOS handles this automatically via CallKit
  }

  /// Disable showing the app over lock screen (for normal screens)
  Future<void> disableShowOnLockScreen() async {
    if (!_isEnabled) return;

    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('disableShowOnLockScreen');
        _isEnabled = false;
      } catch (e) {
        // Ignore errors
      }
    }
  }

  /// Check if currently enabled
  bool get isEnabled => _isEnabled;
}

