import 'dart:io';

import 'package:get/get.dart';

import '../../data/models/user.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class ProfileReviewController extends GetxController {
  String pendingTitle = 'We’re reviewing your profile';
  String rejectedTitle = 'Action required: Profile update needed';

  String pendingContent =
      'To keep our community safe, our team manually verifies every application. Currently making sure your profile aligns with our community guidelines. Sit tight—this process typically takes 2 to 4 days. If something doesn\'t quite match our terms, we’ll reach out with next steps.';
  String rejectedContent =
      'Thank you for your patience. After reviewing your application, we\'re unable to move forward with your profile at this time because it doesn\'t meet our current community requirements. You can find the specific details regarding this decision in your inbox. Please review the highlighted areas and resubmit for a quick check.';

  final approvalStatus = ApprovalStatus.pending.obs;

  @override
  void onInit() {
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      final user = authController.user.value;
      approvalStatus(user.approvalStatus);
    }
    super.onInit();
  }

  void onClosePressed() {
    exit(0);
  }

  void onUpdateProfilePressed() {
    _gotoProfileSetupPage();
  }

  void onSettingsPressed() {
    _gotoSettingsPage();
  }

  void _gotoSettingsPage() {
    Get.toNamed(AppRoutes.accountSettings);
  }

  void _gotoProfileSetupPage() {
    Get.toNamed(AppRoutes.profileSetup);
  }
}
