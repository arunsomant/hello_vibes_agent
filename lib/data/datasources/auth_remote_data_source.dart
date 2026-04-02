import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../models/login.dart';
import '../models/otp.dart';
import '../models/response.dart';
import '../models/user.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required this.apiHelper});

  final ApiBaseHelper apiHelper;

  Future<User> login(String username, String password) async {
    final response = await apiHelper.get('url');
    return User.fromMap(response);
  }

  Future<OtpSendResponse> sendOtp({
    required String mobile,
    required String countryCode,
  }) async {
    final body = {
      'mobile': mobile,
      'dial_code': countryCode,
      'provider_type': null,
    };
    final response = await apiHelper.post(ApiEndpoints.otpSend, body: body);
    return OtpSendResponse.fromMap(response);
  }

  Future<LoginResponse> verifyOtp({
    required String otp,
    required String mobile,
    required String countryCode,
  }) async {
    final body = {'otp': otp, 'mobile': mobile, 'dial_code': countryCode};
    final response = await apiHelper.post(ApiEndpoints.otpVerify, body: body);
    return LoginResponse.fromMap(response);
  }

  Future<LoginResponse> loginUsingFirebase({required String token}) async {
    final body = {'token': token};
    final response = await apiHelper.post(
      ApiEndpoints.firebaseLogin,
      body: body,
    );
    return LoginResponse.fromMap(response);
  }

  Future<AppResponse> logout() async {
    final response = await apiHelper.post(ApiEndpoints.logout);
    return AppResponse.fromMap(response);
  }
}
