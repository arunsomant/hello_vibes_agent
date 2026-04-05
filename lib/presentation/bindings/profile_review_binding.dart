import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/repositories/user_repository.dart';

import '../controllers/profile_review_controller.dart';

class ProfileReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileReviewController>(
      () => ProfileReviewController(userRepository: Get.find<UserRepository>()),
    );
  }
}
