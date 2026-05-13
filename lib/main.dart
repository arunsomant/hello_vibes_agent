import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'app/app.dart';
import 'core/config/firebase_options.dart';
import 'core/services/lock_screen_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if there's an active/accepted call - if so, enable lock screen immediately
  // This handles the case when app is launched from killed state via CallKit
  await _enableLockScreenIfActiveCall();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();
  runApp(const App());
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

