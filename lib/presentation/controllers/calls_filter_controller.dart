import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/app_formatter.dart';
import '../widgets/index.dart';
import 'calls_controller.dart';

class CallsFilterController extends GetxController {
  final callTypes = <String>['Voice', 'Video'];

  final selectedCallType = ''.obs;

  final isFilterApplied = false.obs;

  final fromDateController = TextEditingController();

  final toDateController = TextEditingController();

  void onClosePressed() {
    if (isFilterApplied.isFalse) {
      _clearFilters();
    }
    Get.back();
  }

  void onCallTypeSelected(String callType) {
    selectedCallType(callType);
  }

  void onClearAllPressed() {
    isFilterApplied(false);
    _clearFilters();
    Get.back();
  }

  void _clearFilters() {
    selectedCallType('');
    fromDateController.clear();
    toDateController.clear();
  }

  void onApplyPressed() {
    isFilterApplied(true);
    Get.find<CallsController>().filterTransactions(
      callType: selectedCallType.value,
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
        fromDateController.text = AppFormatter.formatDDMMYYYY(picked);
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
        toDateController.text = AppFormatter.formatDDMMYYYY(picked);
      },
    );
  }
}
