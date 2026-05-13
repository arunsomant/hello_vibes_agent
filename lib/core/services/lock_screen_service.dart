import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service to control showing the app over the lock screen.
///
/// Use this service ONLY for CallingPage:
/// - Call enableShowOnLockScreen() when entering CallingPage
/// - Call disableShowOnLockScreen() when leaving CallingPage
///
/// This ensures only the calling UI appears over the lock screen.
class LockScreenService {
  static final LockScreenService _instance = LockScreenService._internal();
  factory LockScreenService() => _instance;
  LockScreenService._internal();

  static const _channel = MethodChannel('com.mingletalk.agent/lock_screen');

  bool _isEnabled = false;

  /// Enable showing the app over lock screen.
  /// Call this when ENTERING CallingPage.
  Future<bool> enableShowOnLockScreen() async {
    debugPrint('LockScreenService: enableShowOnLockScreen called');

    if (Platform.isAndroid) {
      try {
        final result = await _channel.invokeMethod('enableShowOnLockScreen');
        _isEnabled = true;
        debugPrint('LockScreenService: enableShowOnLockScreen SUCCESS result=$result');
        return true;
      } catch (e) {
        debugPrint('LockScreenService: enableShowOnLockScreen ERROR=$e');
        return false;
      }
    }
    // iOS handles this automatically via CallKit
    return true;
  }

  /// Disable showing the app over lock screen.
  /// Call this when LEAVING CallingPage.
  Future<bool> disableShowOnLockScreen() async {
    debugPrint('LockScreenService: disableShowOnLockScreen called');

    if (Platform.isAndroid) {
      try {
        final result = await _channel.invokeMethod('disableShowOnLockScreen');
        _isEnabled = false;
        debugPrint('LockScreenService: disableShowOnLockScreen SUCCESS result=$result');
        return true;
      } catch (e) {
        debugPrint('LockScreenService: disableShowOnLockScreen ERROR=$e');
        return false;
      }
    }
    return true;
  }

  /// Check if lock screen display is currently enabled
  bool get isEnabled => _isEnabled;
}

