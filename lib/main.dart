import 'dart:async';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'app/app.dart';
import 'core/config/firebase_options.dart';
import 'core/services/lock_screen_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Check if there's an active/accepted call - if so, enable lock screen immediately
    // This handles the case when app is launched from killed state via CallKit
    await _enableLockScreenIfActiveCall();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await NotificationService().initialize();
    FirebaseAnalytics.instance;
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    runApp(const App());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
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

