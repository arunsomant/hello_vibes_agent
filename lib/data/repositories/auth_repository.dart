import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login.dart';
import '../models/otp.dart';
import '../models/response.dart';
import '../models/user.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource = AuthLocalDataSource();

  AuthRepository({required this.remoteDataSource});

  Future<User> login(String username, String password) async {
    return await remoteDataSource.login(username, password);
  }

  Future<String> getAccessToken() async {
    final accessToken = await localDataSource.getAccessToken();
    return accessToken;
  }

  Future<void> saveAccessToken(String token) async {
    await localDataSource.saveAccessToken(token);
  }

  Future<void> clearAccessToken() async {
    await localDataSource.clearAccessToken();
  }

  Future<OtpSendResponse> sendOtp({
    required String mobile,
    required String countryCode,
  }) async {
    return await remoteDataSource.sendOtp(
      mobile: mobile,
      countryCode: countryCode,
    );
  }

  Future<LoginResponse> verifyOtp({
    required String otp,
    required String mobile,
    required String countryCode,
  }) async {
    return await remoteDataSource.verifyOtp(
      otp: otp,
      mobile: mobile,
      countryCode: countryCode,
    );
  }

  Future<AppResponse> logout() async {
    final response = await remoteDataSource.logout();
    return response;
  }

  Future<void> clearAllLocalData() async {
    await localDataSource.clearAll();
  }

  Future<LoginResponse> loginUsingFirebase({required String token}) async {
    return await remoteDataSource.loginUsingFirebase(token: token);
  }

  Future<bool> getOnboardingCompleted() async {
    return await localDataSource.getOnboardingCompleted();
  }

  Future<void> saveOnboardingCompleted(bool completed) async {
    await localDataSource.saveOnboardingCompleted(completed);
  }
}
