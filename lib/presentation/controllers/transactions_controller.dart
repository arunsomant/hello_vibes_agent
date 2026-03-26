import 'package:get/get.dart';
import '../../core/utils/app_extensions.dart';
import '../../data/models/transaction.dart';
import '../../data/repositories/transaction_repository.dart';
import '../pages/landing/transactions_filter.dart';
import '../routes/app_routes.dart';
import '../widgets/index.dart';
import 'transactions_filter_controller.dart';

class TransactionsController extends GetxController {
  TransactionsController({required this.transactionRepository});

  final TransactionRepository transactionRepository;
  final transactions = <Transaction>[].obs;

  bool get isFilterApplied =>
      Get.find<TransactionsFilterController>().isFilterApplied.value;

  final busyTransactions = false.obs;

  @override
  void onInit() {
    _getTransactions();
    super.onInit();
  }

  void onCoinPressed() {
    Get.offUntilOrToNamed(AppRoutes.wallet);
  }

  void onFilterPressed() {
    AppDialog.showBottomSheet(child: TransactionsFilter());
  }

  void filterTransactions({
    required String transactionType,
    required String fromDate,
    required String toDate,
  }) {}

  void _getTransactions() async {
    busyTransactions(true);
    try {
      final response = await transactionRepository.getTransactions();
      if (response.success) {
        transactions(response.paginationResponse.data);
      }
    } catch (_) {
    } finally {
      busyTransactions(false);
    }
  }

  void onRefreshPressed() {
    transactions(const []);
    _getTransactions();
  }
}
