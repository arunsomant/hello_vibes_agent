import 'package:get/get.dart';

import 'auth_controller.dart';
class AccountSettingsController extends GetxController {
  void onCommunityGuidelinesPressed() {}

  void onSafetyCenterPressed() {}

  void onHelpSupportPressed() {}

  void onPrivacyPolicyPressed() {}

  void onTermsConditionsPressed() {}

  void onDeleteAccountPressed() {}

  void onLogoutPressed() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().logout();
    }
  }
}
