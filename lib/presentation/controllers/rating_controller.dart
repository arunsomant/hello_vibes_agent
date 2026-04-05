import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/call.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/repositories/users_repository.dart';
import '../pages/rating/rating_dialog.dart';
import '../widgets/index.dart';

class RatingController extends GetxController {
  RatingController({
    required this.usersRepository,
    required this.callRepository,
  });

  final UsersRepository usersRepository;

  final CallRepository callRepository;

  final busy = false.obs;
  final reportOptions = <String>['Spam/Scam', 'Rude', 'Harassment', 'Other'];

  final selectedReport = false.obs;

  final selectedReportOption = (-1).obs;

  bool get showReportCommentInput =>
      selectedReportOption.value >= reportOptions.length - 1;

  final call = Call().obs;

  final TextEditingController textEditingControllerReview =
      TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null && args is RatingDialogArguments) {
      call(args.call);
    }
    super.onInit();
  }

  void onReportPressed() {
    selectedReport(true);
  }

  void onSubmitReportPressed() {
    if (selectedReport.isTrue && selectedReportOption.value < 0) {
      _showToast('Please select a reason for reporting.');
      return;
    }
    if (showReportCommentInput &&
        textEditingControllerReview.text.trim().isEmpty) {
      _showToast('Please provide details for reporting.');
      return;
    }

    String reason = '';
    if (selectedReportOption.value >= 0 &&
        selectedReportOption.value < reportOptions.length - 1) {
      reason = reportOptions[selectedReportOption.value];
    }
    if (showReportCommentInput) {
      reason = textEditingControllerReview.text.trim();
    }
    _submitReport(reason: reason);
  }

  void _submitReport({required String reason}) async {
    try {
      busy(true);
      final response = await usersRepository.reportCall(
        call: call.value,
        reason: reason,
      );
      _showToast(response.message);
      if (response.success) {
        _clearCallDetails();
        Get.back();
      }
    } catch (_) {
      _showToast('Failed to report. Please try again.');
    } finally {
      busy(false);
    }
  }

  void onFeelingGoodPressed() {
    Get.back();
    _clearCallDetails();
  }

  void onReportItemPressed(int index) {
    selectedReportOption(index);
  }

  void _clearCallDetails() async {
    await callRepository.clearCallDetails();
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}

class ReportOption {
  final String title;
  final selected = false.obs;

  ReportOption(this.title);
}
