import 'package:get/get.dart';

import '../controllers/profile_review_controller.dart';

class ProfileReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileReviewController>(() => ProfileReviewController());
  }
}
