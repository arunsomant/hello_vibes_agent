import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../data/models/call.dart';
import '../../data/models/user.dart';
import '../../presentation/routes/app_routes.dart';

/*void showNotification(int hashCode, String title, String body,
    {Map<String, dynamic>? payload}) {
  flutterLocalNotificationsPlugin.show(
      hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            color: AppColors.primary600,
            enableLights: channel.enableLights,
            channelDescription: channel.description,
            sound: channel.sound,
            playSound: channel.playSound,
            enableVibration: channel.enableVibration,
            importance: channel.importance,
            icon: "ic_notification",
            largeIcon:
                const DrawableResourceAndroidBitmap("@mipmap/launcher_icon"),
            styleInformation: const MediaStyleInformation(
                htmlFormatContent: true, htmlFormatTitle: true)),
      ),
      payload: payload != null ? json.encode(payload) : null);
}*/

class NotificationService {
  Future<void> initialize() async {
    // await Firebase.initializeApp();

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    //FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
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
      //'{call_uuid: 7205dc8a-7fbe-421c-865d-96e5a8dd3e9a, customer_name: Ben Doe, type: incoming_call, call_type: audio, room: call_7205dc8a-7fbe-421c-865d-96e5a8dd3e9a}'

      if (message.data.containsKey('call_uuid')) {
        Get.toNamed(
          Routes.voiceCalling,
          arguments: CallingArguments(
            uuid: message.data['call_uuid'],
            user: User(name: message.data['customer_name']),
          ),
        );
      }
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
