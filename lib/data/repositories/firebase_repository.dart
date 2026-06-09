import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/response.dart';

class FirebaseRepository {
  late final _authLocalDataSource = AuthLocalDataSource();
  final ApiBaseHelper apiHelper;

  FirebaseRepository({required this.apiHelper});

  Future<bool> getDeviceDetailsAdded() async {
    return await _authLocalDataSource.getDeviceDetailsAdded();
  }

  Future<void> saveDeviceDetailsAdded(bool tokenSaved) async {
    await _authLocalDataSource.saveDeviceDetailsAdded(tokenSaved);
  }

  Future<void> clear() async {
    await saveDeviceDetailsAdded(false);
  }

  Future<AppResponse> updateFirebaseToken({
    required String firebaseToken,
    required String voIPToken,
    required String deviceType,
    required String deviceFingerprint,
  }) async {
    var body = {
      'fcm': firebaseToken,
      'device_type': deviceType,
      'device_fingerprint': deviceFingerprint,
    };
    if (voIPToken.isNotEmpty) {
      body.addAll({'voip_token': voIPToken});
    }
    final response = await apiHelper.post(ApiEndpoints.fcmToken, body: body);
    return AppResponse.fromMap(response);
  }
}
