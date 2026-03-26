import 'package:get/get.dart';

import '../routes/app_routes.dart';
import 'auth_controller.dart';

class WalletController extends GetxController {
  final user = Get.find<AuthController>().user;

  int get walletBalance => user.value.walletBalance;

  double get walletBalanceInInr => user.value.walletBalanceInInr;

  double get lifetimeEarningsInInr => user.value.lifetimeEarningsInInr;

  void onRequestRedeemPressed() {
    Get.toNamed(AppRoutes.bankDetails);
  }
}
