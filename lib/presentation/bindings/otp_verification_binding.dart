import 'package:get/get.dart';

import '../../core/network/api_base_helper.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );
    Get.lazyPut<OtpVerificationController>(
      () =>
          OtpVerificationController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
