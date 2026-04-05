import 'package:get/get.dart';

import '../pages/policy/policy_page.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class AccountSettingsController extends GetxController {
  void onCommunityGuidelinesPressed() {
    _gotoGuidelinesPage();
  }

  void onSafetyCenterPressed() {
    _gotoSafetyPage();
  }

  void onCoinPolicyPressed() {
    _gotoCoinPolicyPage();
  }

  void onHelpSupportPressed() {}

  void onPrivacyPolicyPressed() {
    _gotoPrivacyPage();
  }

  void onTermsConditionsPressed() {
    _gotoTermsPage();
  }

  void _gotoPrivacyPage() {
    Get.toNamed(AppRoutes.policy, arguments: PolicyArguments.privacyPolicy());
  }

  void _gotoTermsPage() {
    Get.toNamed(
      AppRoutes.policy,
      arguments: PolicyArguments.termsAndConditions(),
    );
  }

  void _gotoGuidelinesPage() {
    Get.toNamed(
      AppRoutes.policy,
      arguments: PolicyArguments.communityGuidelines(),
    );
  }

  void _gotoSafetyPage() {
    Get.toNamed(AppRoutes.policy, arguments: PolicyArguments.safetyCenter());
  }

  void _gotoCoinPolicyPage() {
    Get.toNamed(AppRoutes.policy, arguments: PolicyArguments.coinPolicy());
  }

  void onDeleteAccountPressed() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().deleteAccount();
    }
  }

  void onLogoutPressed() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().logout();
    }
  }
}
