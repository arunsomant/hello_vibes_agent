import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallkitService {
  Future getVoIPToken() => FlutterCallkitIncoming.getDevicePushTokenVoIP();
}
