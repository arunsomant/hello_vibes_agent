import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/avatar.dart';
import '../models/language.dart';
import '../models/response.dart';
import '../models/user.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource = UserLocalDataSource();

  UserRepository({required this.remoteDataSource});

  Future<bool> getWelcomeDialogShown() async {
    return await localDataSource.getWelcomeDialogShown();
  }

  Future<void> saveWelcomeDialogShown(bool completed) async {
    await localDataSource.saveWelcomeDialogShown(completed);
  }

  Future<UserResponse> getUser() async {
    return await remoteDataSource.getUser();
  }

  Future<AvatarsResponse> getAvatarList() async {
    return await remoteDataSource.getAvatars();
  }

  Future<LanguagesResponse> getLanguages() async {
    return await remoteDataSource.getLanguages();
  }

  Future<AppResponse> updateUserProfile({
    required String name,
    required String gender,
    required DateTime dateOfBirth,
    required int avatarId,
  }) async {
    return await remoteDataSource.updateProfile(
      name: name,
      gender: gender,
      dateOfBirth: dateOfBirth,
      avatarId: avatarId,
    );
  }

  Future<AppResponse> updateLanguages(List<Language> languages) async {
    return await remoteDataSource.updateLanguages(languages: languages);
  }

  Future<AppResponse> onlineStatusUpdate(User user) async {
    return await remoteDataSource.updateOnlineStatus(user: user);
  }
}
