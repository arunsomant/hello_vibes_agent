import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_formatter.dart';
import '../widgets/index.dart';
import 'transactions_controller.dart';

class TransactionsFilterController extends GetxController {
  final transactionTypes = <String>['call', 'withdrawal'];

  final selectedTransactionType = ''.obs;

  final isFilterApplied = false.obs;

  final fromDateController = TextEditingController();

  final toDateController = TextEditingController();

  void onClosePressed() {
    if (isFilterApplied.isFalse) {
      _clearFilters();
    }
    Get.back();
  }

  void onTransactionTypeSelected(String callType) {
    selectedTransactionType(callType);
  }

  void onClearAllPressed() {
    isFilterApplied(false);
    _clearFilters();
    _updateList();
  }

  void _clearFilters() {
    selectedTransactionType('');
    fromDateController.clear();
    toDateController.clear();
  }

  void onApplyPressed() {
    isFilterApplied(true);
    _updateList();
  }

  void _updateList() {
    Get.find<TransactionsController>().filterTransactions(
      transactionType: selectedTransactionType.value,
      fromDate: fromDateController.text,
      toDate: toDateController.text,
    );
    Get.back();
  }

  void onFromDateTap() {
    final selectedFromDate = fromDateController.text.isNotEmpty
        ? DateTime.tryParse(fromDateController.text)
        : null;
    final selectedToDate = toDateController.text.isNotEmpty
        ? DateTime.tryParse(toDateController.text)
        : null;
    AppDialog.showAppDatePicker(
      initialDate: selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(2026, 02, 01),
      lastDate: selectedToDate ?? DateTime.now(),
      onDateSelected: (picked) {
        fromDateController.text = AppFormatter.formatDDMMYYYY2(picked);
      },
    );
  }

  void onToDateTap() {
    final selectedFromDate = fromDateController.text.isNotEmpty
        ? DateTime.tryParse(fromDateController.text)
        : null;
    final selectedToDate = toDateController.text.isNotEmpty
        ? DateTime.tryParse(toDateController.text)
        : null;
    AppDialog.showAppDatePicker(
      initialDate: selectedToDate ?? DateTime.now(),
      firstDate: selectedFromDate ?? DateTime(2026, 02, 01),
      lastDate: DateTime.now(),
      onDateSelected: (picked) {
        toDateController.text = AppFormatter.formatDDMMYYYY2(picked);
      },
    );
  }
}
