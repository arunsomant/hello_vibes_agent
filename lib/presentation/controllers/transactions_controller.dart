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

  int currentPage = 0;

  int lastPage = 0;

  String transactionType = '', fromDate = '', toDate = '';

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

  void onRefreshPressed() {
    _refresh();
  }

  void _refresh() {
    currentPage = 0;
    lastPage = 0;
    transactions([]);
    _getTransactions();
  }

  void getNextTransactions() {
    if (currentPage < lastPage && busyTransactions.isFalse) {
      _getTransactions();
    }
  }

  void filterTransactions({
    required String transactionType,
    required String fromDate,
    required String toDate,
  }) {
    this.transactionType = transactionType;
    this.fromDate = fromDate;
    this.toDate = toDate;
    _refresh();
  }

  void _getTransactions() async {
    busyTransactions(true);
    try {
      final response = await transactionRepository.getTransactions(
        nextPage: currentPage + 1,
        transactionType: transactionType,
        fromDate: fromDate,
        toDate: toDate,
      );
      if (response.success) {
        currentPage = response.paginationResponse.currentPage;
        lastPage = response.paginationResponse.lastPage;
        if (currentPage == 1) {
          transactions(response.paginationResponse.data);
        } else {
          transactions.addAll(response.paginationResponse.data);
        }
      }
    } catch (_) {
    } finally {
      busyTransactions(false);
    }
  }
}
