import 'dart:io';

import 'package:get/get.dart';

import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class ProfileReviewController extends GetxController {

  ProfileReviewController({required this.userRepository});

  String pendingTitle = 'We’re reviewing your profile';
  String rejectedTitle = 'Action required: Profile update needed';

  String pendingContent =
      'To keep our community safe, our team manually verifies every application. Currently making sure your profile aligns with our community guidelines. Sit tight—this process typically takes 2 to 4 days. If something doesn\'t quite match our terms, we’ll reach out with next steps.';
  final rejectedContent = ''.obs;
  final approvalStatus = ApprovalStatus.pending.obs;

  final UserRepository userRepository;

  @override
  void onInit() {
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      final user = authController.user.value;
      approvalStatus(user.approvalStatus);
      rejectedContent(user.reason);
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
