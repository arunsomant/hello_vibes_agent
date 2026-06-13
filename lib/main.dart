import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pusher_reverb_flutter/pusher_reverb_flutter.dart';

import 'app/app.dart';
import 'core/config/firebase_options.dart';
import 'core/services/lock_screen_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Check if there's an active/accepted call - if so, enable lock screen immediately
      // This handles the case when app is launched from killed state via CallKit
      await _enableLockScreenIfActiveCall();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await NotificationService().initialize();
      FirebaseAnalytics.instance;
      FlutterError.onError = (errorDetails) {
        if (_isSuppressedError(errorDetails.exception)) return;
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        if (_isSuppressedError(error)) return true;
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      runApp(const App());
    },
    (error, stack) {
      if (_isSuppressedError(error)) return;
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

/// Returns true for transient, non-actionable errors that should not
/// be recorded as crashes in Firebase Crashlytics.
bool _isSuppressedError(Object error) {
  if (error is SocketException) return true;
  if (error is NegotiationError) return true;
  if (error is ConnectionException) return true;
  if (error is IOException) return true;
  if (error is TimeoutException) return true;
  final msg = error.toString();
  if (msg.contains('SocketException') ||
      msg.contains('Reading from a closed socket')) {
    return true;
  }

  return false;
}

/// Check for active calls and enable lock screen display if found
Future<void> _enableLockScreenIfActiveCall() async {
  try {
    final List<dynamic> calls = await FlutterCallkitIncoming.activeCalls();
    if (calls.isNotEmpty) {
      debugPrint('main: Active call found, enabling lock screen');
      await LockScreenService().enableShowOnLockScreen();
    }
  } catch (e) {
    debugPrint('main: Error checking active calls: $e');
  }
}
