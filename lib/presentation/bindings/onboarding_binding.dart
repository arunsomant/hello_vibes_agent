import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/repositories/auth_repository.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
