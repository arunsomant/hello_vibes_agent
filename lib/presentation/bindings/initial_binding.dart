import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_base_helper.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());
    Get.put<ApiClient>(ApiClient(), permanent: true);
    final apiClient = Get
        .find<ApiClient>()
        .http;
    Get.put<ApiBaseHelper>(
      ApiBaseHelper(baseUrl: AppConfig.apiBaseUrl, http: apiClient),
      permanent: true,
    );

    Get.lazyPut<AuthRemoteDataSource>(
          () => AuthRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<UserRemoteDataSource>(
          () => UserRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );

    Get.lazyPut<AuthRepository>(
          () =>
          AuthRepository(remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );
    Get.lazyPut<UserRepository>(
          () =>
          UserRepository(remoteDataSource: Get.find<UserRemoteDataSource>()),
    );
    Get.put<AuthController>(
      AuthController(
        authRepository: Get.find<AuthRepository>(),
        userRepository: Get.find<UserRepository>(),
      ),
      permanent: true,
    );
  }
}
