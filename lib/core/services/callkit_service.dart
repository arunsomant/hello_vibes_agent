import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:mingle_talk_agent/core/theme/app_colors.dart';
import 'package:mingle_talk_agent/data/models/call.dart';

import '../utils/app_extensions.dart';

class CallkitService {
  Future getVoIPToken() => FlutterCallkitIncoming.getDevicePushTokenVoIP();

  Future<void> showCallNotification(CallAlertNotification data) async {
    final callUuid = data.uuid;
    final customerName = data.customerName;
    final customerAvatar = data.customerAvatar;

    CallKitParams callKitParams = CallKitParams(
      id: callUuid,
      nameCaller: customerName,
      appName: 'Mingle Talk',
      avatar: customerAvatar,
      //Fallback or retrieve from payloads
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
      extra: data.toMap(),
      android: AndroidParams(
        textColor: AppColors.textPrimary.toHex(),
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: AppColors.backgroundPage.toHex(),
        //actionColor: '#4CAF50',
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

  Future<void> dismissCallNotification(CallAlertNotification data) {
    final callUuid = data.uuid;
    return FlutterCallkitIncoming.endCall(callUuid);
  }

  Future<void> dismissAllCallNotification() {
    return FlutterCallkitIncoming.endAllCalls();
  }

  void initCallkitListeners({
    Function(Map<String, dynamic>? callData)? onCallAccept,
    Function(Map<String, dynamic>? callData)? onCallDecline,
  }) {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      if (event == null) return;
      switch (event.event) {
        case Event.actionCallAccept:
          final callData = (event.body['extra'])?.cast<String, dynamic>();
          onCallAccept?.call(callData);
          break;
        case Event.actionCallDecline:
          final callData = (event.body['extra'])?.cast<String, dynamic>();
          onCallDecline?.call(callData);
          break;
        default:
          break;
      }
    });
  }
}
