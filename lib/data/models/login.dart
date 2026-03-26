import 'response.dart';
import 'user.dart';

class LoginResponse {
  final bool success;
  final Login loginData;
  final String message;

  LoginResponse({
    this.success = false,
    this.loginData = const Login(),
    this.message = '',
  });

  factory LoginResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    Login loginData = const Login();

    if (json['data'] != null) {
      if (success) {
        loginData = Login.fromMap(json['data']);
      } else {
        message =
            '$message ${AppResponse.parseErrorResponse(json['data']).join(',')}';
      }
    }
    return LoginResponse(
      success: success,
      loginData: loginData,
      message: message,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'data': loginData.toMap(),
    'message': message,
  };
}

class Login {
  final String token;
  final String tokenType;
  final User user;
  final String type;
  final String approvalStatus;
  final dynamic reason;
  final bool isVerifiedAgent;

  const Login({
    this.token = '',
    this.tokenType = '',
    this.user = const User(),
    this.type = '',
    this.approvalStatus = '',
    this.reason,
    this.isVerifiedAgent = false,
  });

  factory Login.fromMap(Map<String, dynamic> json) => Login(
    token: json['token'] ?? '',
    tokenType: json['token_type'] ?? '',
    user: json['user'] != null ? User.fromMap(json['user']) : const User(),
    type: json['type'] ?? '',
    approvalStatus: json['approval_status'] ?? '',
    reason: json['reason'] ?? '',
    isVerifiedAgent: json['is_verified_agent'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'token': token,
    'token_type': tokenType,
    'user': user.toMap(),
    'type': type,
    'approval_status': approvalStatus,
    'reason': reason,
    'is_verified_agent': isVerifiedAgent,
  };
}
