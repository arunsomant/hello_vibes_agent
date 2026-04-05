import '../../core/utils/app_extensions.dart';
import 'response.dart';

class OtpSendResponse {
  final bool success;
  final String message;

  OtpSendResponse({this.success = false, this.message = ''});

  factory OtpSendResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    if (!success) {
      message =
          '$message ${AppResponse.parseErrorResponse(json['data']).join(',')}';
    }

    return OtpSendResponse(success: success, message: message);
  }

  Map<String, dynamic> toMap() => {'success': success, 'message': message};
}

enum OtpProviderType implements JsonEnum {
  sms('sms'),
  whatsapp('whatsapp');

  @override
  final String value;

  @override
  OtpProviderType get defaultValue => OtpProviderType.whatsapp;

  const OtpProviderType(this.value);
}
