import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/repositories/user_repository.dart';

import '../controllers/profile_setup_controller.dart';

class ProfileEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSetupController>(
      () => ProfileSetupController(userRepository: Get.find<UserRepository>()),
    );
  }
}
