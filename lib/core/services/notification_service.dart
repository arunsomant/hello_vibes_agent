import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/models/avatar.dart';

import '../../data/models/call.dart';
import '../../data/models/user.dart';
import '../../data/repositories/call_repository.dart';
import '../../presentation/routes/app_routes.dart';
import '../config/firebase_options.dart';
import 'alert_notification_service.dart';
import 'callkit_service.dart';
import 'lock_screen_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");

  debugPrint("Message data: ${message.data}");

  _handleMessage(message);

  debugPrint('Message also contained a notification: ${message.notification}');
  if (message.notification == null) {
    return;
  }
}

void _handleMessage(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  initCallkitListeners();
  final alert = AlertNotification.fromMap(data);

  // Use centralized handler in AlertNotificationService
  await AlertNotificationService().handleAlertNotification(alert);

  if (message.notification != null) {
    showNotification(
      message.notification!.hashCode,
      message.notification!.title!,
      message.notification!.body!,
      payload: message.data,
    );
  }
}

void initCallkitListeners() {
  CallkitService().initCallkitListeners(
    onCallAccept: (callData) async {
      if (callData != null) {
        // Enable lock screen display BEFORE navigating to calling screen
        // This is critical for calls accepted from killed state
        await LockScreenService().enableShowOnLockScreen();

        // Small delay to ensure native flags are applied
        await Future.delayed(const Duration(milliseconds: 100));

        final call = AlertNotification.fromMap(callData);
        final uuid = call.uuid;
        final customerName = call.customerName;
        final avatar = call.customerAvatar;
        final user = User(
          name: customerName,
          avatar: Avatar(url: avatar),
        );
        if (call.callType == CallType.video) {
          _navigateToVideoCalling(uuid, user);
        } else {
          _navigateToVoiceCalling(uuid, user);
        }
      }
    },
    onCallDecline: (callData) async {
      if (callData != null) {
        final call = AlertNotification.fromMap(callData);
        final uuid = call.uuid;
        try {
          await CallRepository.instance().rejectCall(call: Call(uuid: uuid));
        } catch (_) {}
      }
    },
  );
}

void _navigateToVoiceCalling(String uuid, User user) {
  Get.toNamed(
    AppRoutes.voiceCalling,
    arguments: CallingArguments(
      uuid: uuid,
      user: user,
      callType: CallType.audio,
    ),
  );
}

void _navigateToVideoCalling(String uuid, User user) {
  Get.toNamed(
    AppRoutes.videoCalling,
    arguments: CallingArguments(
      uuid: uuid,
      user: user,
      callType: CallType.video,
    ),
  );
}

void showNotification(
  int hashCode,
  String title,
  String body, {
  Map<String, dynamic>? payload,
}) {
  flutterLocalNotificationsPlugin.show(
    id: hashCode,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        enableLights: channel.enableLights,
        channelDescription: channel.description,
        sound: channel.sound,
        playSound: channel.playSound,
        enableVibration: channel.enableVibration,
        importance: channel.importance,
        //icon: "ic_notification",  // todo add notification icon
        largeIcon: const DrawableResourceAndroidBitmap("@mipmap/launcher_icon"),
        styleInformation: const MediaStyleInformation(
          htmlFormatContent: true,
          htmlFormatTitle: true,
        ),
      ),
    ),
    payload: payload != null ? json.encode(payload) : null,
  );
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'main_channel', // id
  'All MTA Notifications', // title
  description: 'MTA Default Notifications',
  enableLights: true,
  playSound: true,
  enableVibration: true,
  importance: Importance.max,
  showBadge: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    initCallkitListeners();

    _requestPermissions();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // handle when app in active state
    foregroundNotification();

    // handle when app running in background state
    backgroundNotification();

    // handle when app completely closed by the user
    terminateNotification();

    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('on click called');
        if (details.payload != null) {
          try {} catch (_) {}
        }
      },
    );
  }

  Future<void> foregroundNotification() async {
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((message) async {
      print('Handling a foregroundNotification message ${message.messageId}');
      /*if (Get.isRegistered<LandingController>()) {
          Get.find<LandingController>().getNotificationsCount();
        }*/
      print("Message data: ${message.data}");
      //'{reason: , call_uuid: 9824bc11-db24-4d63-9e3d-b8bf6cdd51a1, type: call_ended}'
      //'{call_uuid: 7205dc8a-7fbe-421c-865d-96e5a8dd3e9a, customer_name: Ben Doe, type: incoming_call, call_type: audio, room: call_7205dc8a-7fbe-421c-865d-96e5a8dd3e9a}'

      _handleMessage(message);

      print('Message also contained a notification: ${message.notification}');
      if (message.notification == null) {
        return;
      }
    });
  }

  void backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      /*if (Get.isRegistered<LandingController>()) {
          Get.find<LandingController>().getNotificationsCount();
        }*/
      print("Message data: ${message.data}");
      print('Message also contained a notification: ${message.notification}');
      if (message.data.containsKey('type')) {
        msgHandler(message);
      }
    });
  }

  Future<void> terminateNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data.containsKey('type')) {
        Future.delayed(
          const Duration(milliseconds: 1000),
          () => msgHandler(initialMessage),
        );
      }
    }
  }

  void msgHandler(RemoteMessage message) {
    debugPrint("Handling a message in msgHandler: ${message.messageId}");
    debugPrint("Message data: ${message.data}");
    debugPrint(
      'Message also contained a notification: ${message.notification}',
    );
    // Handle the message based on its type or content
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
    }
  }
}
