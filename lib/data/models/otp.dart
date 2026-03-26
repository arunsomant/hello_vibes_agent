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
