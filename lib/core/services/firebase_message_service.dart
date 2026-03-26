import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageService {
  Future<String?> getToken() => FirebaseMessaging.instance.getToken();
}
