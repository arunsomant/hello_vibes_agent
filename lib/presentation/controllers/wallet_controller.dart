import 'package:get/get.dart';

import '../routes/app_routes.dart';
import 'auth_controller.dart';
import 'landing_controller.dart';

class WalletController extends GetxController {
  final user = Get.find<AuthController>().user;

  int get walletBalance => user.value.walletBalance;

  double get walletBalanceInInr => user.value.walletBalanceInInr;

  double get lifetimeEarningsInInr => user.value.lifetimeEarningsInInr;

  void onRequestRedeemPressed() {
    Get.toNamed(AppRoutes.bankDetails);
  }

  void onTransactionHistoryPressed() {
    _gotoTransactionHistoryPage();
  }

  void _gotoTransactionHistoryPage() {
    if (Get.isRegistered<LandingController>()) {
      Get.offNamedUntil(AppRoutes.landing, (route) => true);
      final landingController = Get.find<LandingController>();
      landingController.onTabClicked(1);
    }
  }
}
