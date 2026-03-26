import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/response.dart';

class FirebaseRepository {
  late final _authLocalDataSource = AuthLocalDataSource();
  final ApiBaseHelper apiHelper;

  FirebaseRepository({required this.apiHelper});

  Future<bool> getFirebaseTokenSaved() async {
    return await _authLocalDataSource.getFirebaseTokenSaved();
  }

  Future<void> saveFirebaseTokenSaved(bool tokenSaved) async {
    await _authLocalDataSource.saveFirebaseTokenSaved(tokenSaved);
  }

  Future<void> clear() async {
    await saveFirebaseTokenSaved(false);
  }

  Future<AppResponse> updateFirebaseToken(
    String firebaseToken, {
    String? voIPToken,
  }) async {
    var body = {'fcm': firebaseToken};
    if (voIPToken != null && voIPToken.isNotEmpty) {
      body.addAll({'voip_token': voIPToken});
    }
    final response = await apiHelper.post(ApiEndpoints.fcmToken, body: body);
    return AppResponse.fromMap(response);
  }
}
