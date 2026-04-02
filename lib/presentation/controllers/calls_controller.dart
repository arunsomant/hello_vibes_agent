import 'package:get/get.dart';

import '../../data/models/call.dart';
import '../../data/repositories/call_repository.dart';
import '../pages/landing/calls_filter.dart';
import '../routes/app_routes.dart';
import '../widgets/index.dart';
import 'auth_controller.dart';
import 'calls_filter_controller.dart';

class CallsController extends GetxController {
  CallsController({required this.callRepository});

  final CallRepository callRepository;

  final calls = <Call>[].obs;

  final busyCalls = false.obs;

  double get walletBalance =>
      Get.find<AuthController>().user.value.walletBalanceInInr;

  bool get isFilterApplied =>
      Get.find<CallsFilterController>().isFilterApplied.value;

  int currentPage = 0;

  int lastPage = 0;

  @override
  void onInit() {
    _getCalls();
    super.onInit();
  }

  void onFilterPressed() {
    AppDialog.showBottomSheet(child: CallsFilter());
  }

  void filterTransactions({
    required String callType,
    required String fromDate,
    required String toDate,
  }) {}

  void onRefresh() {
    currentPage = 0;
    lastPage = 0;
    calls([]);
    _getCalls();
  }

  void getNextCalls() {
    if (currentPage < lastPage && busyCalls.isFalse) {
      _getCalls();
    }
  }

  void _getCalls() async {
    try {
      busyCalls(true);
      final response = await callRepository.getCalls(nextPage: currentPage + 1);
      if (response.success) {
        currentPage = response.paginationResponse.currentPage;
        lastPage = response.paginationResponse.lastPage;
        if (currentPage == 1) {
          calls(response.paginationResponse.data);
        } else {
          calls.addAll(response.paginationResponse.data);
        }
      }
    } catch (_) {
      _showToast('Failed to load calls');
    } finally {
      busyCalls(false);
    }
  }

  void onWalletBannerPressed() {
    _gotoWalletPage();
  }

  void _gotoWalletPage() {
    Get.toNamed(AppRoutes.wallet);
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
