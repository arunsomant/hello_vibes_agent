import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/repositories/transaction_repository.dart';

import '../../core/network/api_base_helper.dart';
import '../../data/datasources/transaction_remote_data_source.dart';
import '../controllers/bank_details_controller.dart';

class BankDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(
        remoteDataSource: Get.find<TransactionRemoteDataSource>(),
      ),
    );
    Get.lazyPut<BankDetailsController>(
      () => BankDetailsController(
        transactionRepository: Get.find<TransactionRepository>(),
      ),
    );
  }
}
