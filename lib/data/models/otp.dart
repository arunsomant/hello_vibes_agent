import '../../core/utils/app_extensions.dart';
import 'response.dart';

class OtpSendResponse {
  final bool success;
  final String message;
  final String otp;
  final List<OtpProviderType> availableProviders;

  OtpSendResponse({
    this.success = false,
    this.message = '',
    this.otp = '',
    this.availableProviders = const [],
  });

  factory OtpSendResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    String otp = json.containsKey('data')
        ? json['data']['otp_debug'] ?? ''
        : '';
    if (!success && json.containsKey('data')) {
      message =
          '$message ${AppResponse.parseErrorResponse(json['data']).join(',')}';
    }
    final List<OtpProviderType> availableProviders =
        json['data']['available_providers'] != null
        ? List<OtpProviderType>.from(
            json['data']['available_providers'].map(
              (x) => OtpProviderType.values.fromJson(x),
            ),
          )
        : const [];

    return OtpSendResponse(
      success: success,
      message: message,
      otp: otp,
      availableProviders: availableProviders,
    );
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
