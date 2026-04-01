import 'package:get/get.dart';

import '../../data/models/user.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  User get user => Get.find<AuthController>().user.value;

  String profileImageHeroTag = '';

  @override
  void onInit() {
    super.onInit();
  }

  void onEditPressed() {
    _gotoProfileEdit();
  }

  void onLanguagePreferencePressed() {
    _gotoLanguagePreference();
  }

  void onWalletPressed() {
    _gotoWallet();
  }

  void onAccountSettingsPressed() {
    _gotoAccountSettings();
  }

  void _gotoWallet() {
    Get.toNamed(AppRoutes.wallet);
  }

  void _gotoAccountSettings() {
    Get.toNamed(AppRoutes.accountSettings);
  }

  void _gotoProfileEdit() {
    Get.toNamed(AppRoutes.profileEdit);
  }

  void _gotoLanguagePreference() {
    Get.toNamed(AppRoutes.languageSelection);
  }
}
