import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../models/avatar.dart';
import '../models/language.dart';
import '../models/response.dart';
import '../models/user.dart';

class UserRemoteDataSource {
  UserRemoteDataSource({required this.apiHelper});

  final ApiBaseHelper apiHelper;

  Future<UserResponse> getUser() async {
    final response = await apiHelper.get(ApiEndpoints.profile);
    print(response);
    return UserResponse.fromMap(response);
  }

  Future<AvatarsResponse> getAvatars() async {
    final response = await apiHelper.get(ApiEndpoints.avatars);
    return AvatarsResponse.fromMap(response);
  }

  Future<LanguagesResponse> getLanguages() async {
    final response = await apiHelper.get(ApiEndpoints.languages);
    return LanguagesResponse.fromMap(response);
  }

  Future<AppResponse> updateProfile({
    String name = '',
    String gender = '',
    DateTime? dateOfBirth,
    int avatarId = 0,
  }) async {
    final body = {
      'name': name,
      'gender': gender,
      'avatar_id': avatarId,
      'dob': dateOfBirth?.toIso8601String(),
    };
    final response = await apiHelper.post(
      ApiEndpoints.profileUpdate,
      body: body,
    );
    return AppResponse.fromMap(response);
  }

  Future<AppResponse> updateLanguages({
    List<Language> languages = const [],
  }) async {
    final body = {'languages': List<dynamic>.from(languages.map((e) => e.id))};
    final response = await apiHelper.post(
      ApiEndpoints.profileUpdate,
      body: body,
    );
    return AppResponse.fromMap(response);
  }

  Future<AppResponse> updateOnlineStatus({required User user}) async {
    final body = {'is_online': user.isOnline};
    final response = await apiHelper.post(
      ApiEndpoints.updateOnlineStatus,
      body: body,
    );
    return AppResponse.fromMap(response);
  }
}
