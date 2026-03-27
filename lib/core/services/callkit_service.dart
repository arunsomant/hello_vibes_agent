import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallkitService {
  Future getVoIPToken() => FlutterCallkitIncoming.getDevicePushTokenVoIP();

  Future<void> showCallNotification(Map<String, dynamic> data) async {
    final callUuid = data['call_uuid']?.toString() ?? 'unknown-uuid';
    final customerName = data['customer_name']?.toString() ?? 'Incoming Call';

    CallKitParams callKitParams = CallKitParams(
      id: callUuid,
      nameCaller: customerName,
      appName: 'Mingle Talk',
      avatar: 'https://i.pravatar.cc/100',
      // Fallback or retrieve from payloads
      handle: '',
      // Number or handle
      type: 0,
      // 0 for Audio, 1 for Video
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: data,
      headers: <String, dynamic>{'apiKey': 'v1.0!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: false,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  Future<void> dismissCallNotification(Map<String, dynamic> data) {
    final callUuid = data['call_uuid']?.toString() ?? 'unknown-uuid';
    return FlutterCallkitIncoming.endCall(callUuid);
  }

  void initCallkitListeners({
    Function(Map<dynamic, dynamic>? callData)? onCallAccept,
    Function(Map<dynamic, dynamic>? callData)? onCallDecline,
  }) {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      if (event == null) return;
      switch (event.event) {
        case Event.actionCallAccept:
          final callData = event.body['extra'] as Map<dynamic, dynamic>?;
          onCallAccept?.call(callData);
          break;
        case Event.actionCallDecline:
          final callData = event.body['extra'] as Map<dynamic, dynamic>?;
          onCallDecline?.call(callData);
          break;
        default:
          break;
      }
    });
  }
}
