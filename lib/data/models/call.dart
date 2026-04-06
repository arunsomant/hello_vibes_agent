import '../../core/utils/app_extensions.dart';
import 'response.dart';
import 'user.dart';

class CallingArguments {
  final User user;
  final String uuid;
  final CallType callType;

  CallingArguments({
    required this.user,
    required this.uuid,
    required this.callType,
  });
}

class CallsResponse {
  final bool success;
  final PaginationResponse<Call> paginationResponse;
  final String message;

  CallsResponse({
    required this.success,
    required this.paginationResponse,
    required this.message,
  });

  factory CallsResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    return CallsResponse(
      success: success,
      paginationResponse: json['data'] != null && json['data']['calls'] != null
          ? PaginationResponse<Call>.fromMap(
              json['data'],
              json['data']['calls'],
              Call.fromMap,
            )
          : const PaginationResponse(),
      message: message,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'data': {'calls': paginationResponse.toMap((value) => value.toMap())},
    'message': message,
  };
}

class CallResponse {
  final bool success;
  final Call call;
  final String message;
  final String livekitUrl;
  final String token;

  const CallResponse({
    this.success = false,
    this.call = const Call(),
    this.message = '',
    this.livekitUrl = '',
    this.token = '',
  });

  factory CallResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    Call call = const Call();
    String livekitUrl = '';
    String token = '';

    if (json['data'] != null) {
      if (success && json['data']['call'] != null) {
        call = Call.fromMap(json['data']['call']);
        livekitUrl = json['data']['livekit_url'] ?? '';
        token = json['data']['token'] ?? '';
      } else {
        message =
            '$message ${AppResponse.parseErrorResponse(json['data']).join(',')}';
      }
    }
    return CallResponse(
      success: success,
      call: call,
      message: message,
      livekitUrl: livekitUrl,
      token: token,
    );
  }

  Map<String, dynamic> toMap() => {'success': success, 'data': call.toMap()};
}

class Call {
  final int id;
  final String uuid;
  final User participant;
  final CallType type;
  final CallStatus status;
  final int durationSeconds;
  final String duration;
  final int coins;
  final DateTime? initiatedAt;
  final DateTime? startedAt;
  final DateTime? endedAt;

  const Call({
    this.id = 0,
    this.uuid = '',
    this.participant = const User(),
    this.type = CallType.none,
    this.status = CallStatus.none,
    this.durationSeconds = 0,
    this.duration = '',
    this.coins = 0,
    this.initiatedAt,
    this.startedAt,
    this.endedAt,
  });

  factory Call.fromMap(Map<String, dynamic> json) {
    User user = User();
    if (json['participant'] != null) {
      user = User.fromMap(json['participant']);
    } else if (json['agent'] != null) {
      user = User.fromMap(json['agent']);
    }

    return Call(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      participant: user,
      type: CallType.values.fromJson(json['type']),
      status: CallStatus.values.fromJson(json['status']),
      durationSeconds: json['duration_seconds'] ?? 0,
      duration: json['duration'] ?? '',
      coins: json['coins'] ?? 0,
      initiatedAt: DateTime.tryParse(json['initiated_at'] ?? '')?.toLocal(),
      startedAt: DateTime.tryParse(json['started_at'] ?? '')?.toLocal(),
      endedAt: DateTime.tryParse(json['ended_at'] ?? '')?.toLocal(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'uuid': uuid,
    'participant': participant.toMap(),
    'type': type.value,
    'status': status.value,
    'duration_seconds': durationSeconds,
    'duration': duration,
    'coins': coins,
    'initiated_at': initiatedAt?.toIso8601String(),
    'started_at': startedAt?.toIso8601String(),
    'ended_at': endedAt?.toIso8601String(),
  };
}

enum CallType implements JsonEnum {
  video('video'),
  audio('audio'),
  none('none');

  @override
  final String value;

  @override
  CallType get defaultValue => CallType.none;

  const CallType(this.value);
}

enum CallStatus implements JsonEnum {
  none('none'),
  initiated('initiated'),
  ringing('ringing'),
  rejected('rejected'),
  agentJoined('agent_joined'),
  ended('ended');

  @override
  final String value;

  @override
  CallStatus get defaultValue => CallStatus.none;

  const CallStatus(this.value);
}

enum NotificationType implements JsonEnum {
  incomingCall('incoming_call'),
  callEnded('call_ended'),
  callRejected('call_rejected');

  @override
  final String value;

  @override
  NotificationType get defaultValue => NotificationType.incomingCall;

  const NotificationType(this.value);
}

class AlertNotification {
  final String uuid;
  final String customerName;
  final String customerAvatar;
  final CallType callType;
  final NotificationType notificationType;
  final AlertReason reason;

  AlertNotification({
    this.uuid = '',
    this.customerName = '',
    this.customerAvatar = '',
    this.callType = CallType.none,
    this.notificationType = NotificationType.incomingCall,
    this.reason = AlertReason.none,
  });

  factory AlertNotification.fromMap(Map<String, dynamic> json) {
    return AlertNotification(
      uuid: json['call_uuid'] ?? '',
      customerName: json['customer_name'] ?? 'Unknown Caller',
      customerAvatar: json['customer_avatar'] ?? '',
      callType: CallType.values.fromJson(json['call_type']),
      notificationType: NotificationType.values.fromJson(json['type']),
      reason: AlertReason.values.fromJson(json['reason']),
    );
  }

  Map<String, dynamic> toMap() => {
    'call_uuid': uuid,
    'customer_name': customerName,
    'customer_avatar': customerAvatar,
    'call_type': callType.value,
    'type': notificationType.value,
    'reason': reason.value,
  };
}

enum AlertReason implements JsonEnum {
  none('none'),
  insufficientBalance('insufficient_balance'),
  adminForceEnd('admin_force_end'),
  customerEnded('customer_ended'),
  agentEnded('agent_ended'),
  stuckCallRecovered('stuck_call_recovered'),
  ringTimeout('ring_timeout');

  @override
  final String value;

  @override
  AlertReason get defaultValue => AlertReason.none;

  const AlertReason(this.value);
}
