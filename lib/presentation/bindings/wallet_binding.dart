import 'package:get/get.dart';

import '../../data/repositories/transaction_repository.dart';
import '../controllers/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(
      () => WalletController(
        transactionRepository: Get.find<TransactionRepository>(),
      ),
    );
  }
}
