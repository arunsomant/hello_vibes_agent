import 'package:get/get.dart';
import '../../core/network/api_base_helper.dart';
import '../../data/datasources/transaction_remote_data_source.dart';
import '../../data/repositories/transaction_repository.dart';
import '../controllers/transactions_controller.dart';
import '../controllers/transactions_filter_controller.dart';

class TransactionsBinding extends Bindings {
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
    Get.lazyPut<TransactionsController>(
      () => TransactionsController(
        transactionRepository: Get.find<TransactionRepository>(),
      ),
    );
    Get.put<TransactionsFilterController>(
      TransactionsFilterController(),
      permanent: true,
    );
  }
}
