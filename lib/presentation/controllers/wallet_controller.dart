import 'package:get/get.dart';
import 'package:mingle_talk_agent/presentation/controllers/bank_details_controller.dart';

import '../../data/repositories/transaction_repository.dart';
import '../routes/app_routes.dart';
import '../widgets/index.dart';
import 'auth_controller.dart';
import 'landing_controller.dart';

class WalletController extends GetxController {
  final TransactionRepository transactionRepository;

  WalletController({required this.transactionRepository});

  final busyRequest = false.obs;

  final user = Get.find<AuthController>().user;

  int get walletBalance => user.value.walletBalance;

  double get walletBalanceInInr => user.value.walletBalanceInInr;

  double get lifetimeEarningsInInr => user.value.lifetimeEarningsInInr;

  final bankDetailsController = Get.find<BankDetailsController>();

  bool get bankDetailsAdded => bankDetailsController.bankDetailsAdded.isTrue;

  String get name => bankDetailsController.name.value;

  String get bankName => bankDetailsController.bankName.value;

  String get accountNumber => bankDetailsController.accountNumber.value;

  String get ifscCode => bankDetailsController.ifscCode.value;

  void onRequestRedeemPressed() {
    _requestRedeem();
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

  void onEditBankDetailsPressed() {
    _gotoBankDetailsPage();
  }

  void _gotoBankDetailsPage() {
    Get.toNamed(AppRoutes.bankDetails);
  }

  void _requestRedeem() async {
    try {
      busyRequest(true);
      final coins = walletBalance;
      final response = await transactionRepository.requestWithdrawal(
        coins: coins,
      );
      if (response.success) {
        Get.back();
      }
      _showToast(response.message);
    } catch (_) {
      _showToast('Request failed. Please try again.');
    } finally {
      busyRequest(false);
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
