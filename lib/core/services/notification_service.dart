import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../data/models/call.dart';
import '../../data/models/user.dart';
import '../../data/repositories/call_repository.dart';
import '../../presentation/routes/app_routes.dart';
import '../config/firebase_options.dart';
import 'callkit_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");

  print("Message data: ${message.data}");

  _handleMessage(message);

  print('Message also contained a notification: ${message.notification}');
  if (message.notification == null) {
    return;
  }
}

void _handleMessage(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  initCallkitListeners();
  final call = CallAlertNotification.fromMap(data);
  if (call.callAlertType == CallAlertType.incomingCall) {
    if (message.sentTime == null ||
        DateTime.now().difference(message.sentTime!.toLocal()) >
            const Duration(minutes: 1)) {
      return;
    }
    await CallkitService().showCallNotification(call);
  }
  if (call.callAlertType == CallAlertType.callEnded) {
    await CallkitService().dismissCallNotification(call);
  }
}

void initCallkitListeners() {
  CallkitService().initCallkitListeners(
    onCallAccept: (callData) {
      if (callData != null) {
        final call = CallAlertNotification.fromMap(callData);
        final uuid = call.uuid;
        final customerName = call.customerName;
        if (call.callType == CallType.video) {
          _navigateToVideoCalling(uuid, customerName);
        } else {
          _navigateToVoiceCalling(uuid, customerName);
        }
      }
    },
    onCallDecline: (callData) async {
      if (callData != null) {
        final call = CallAlertNotification.fromMap(callData);
        final uuid = call.uuid;
        try {
          await CallRepository.instance().rejectCall(call: Call(uuid: uuid));
        } catch (_) {}
      }
    },
  );
}

void _navigateToVoiceCalling(dynamic uuid, dynamic customerName) {
  Get.toNamed(
    AppRoutes.voiceCalling,
    arguments: CallingArguments(
      uuid: uuid,
      user: User(name: customerName ?? 'Unknown Caller'),
      callType: CallType.audio,
    ),
  );
}

void _navigateToVideoCalling(dynamic uuid, dynamic customerName) {
  Get.toNamed(
    AppRoutes.videoCalling,
    arguments: CallingArguments(
      uuid: uuid,
      user: User(name: customerName ?? 'Unknown Caller'),
      callType: CallType.video,
    ),
  );
}

class NotificationService {
  Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    initCallkitListeners();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // handle when app in active state
    foregroundNotification();

    // handle when app running in background state
    backgroundNotification();

    // handle when app completely closed by the user
    terminateNotification();
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
    print("Handling a message in msgHandler: ${message.messageId}");
    print("Message data: ${message.data}");
    print('Message also contained a notification: ${message.notification}');
    // Handle the message based on its type or content
  }
}
