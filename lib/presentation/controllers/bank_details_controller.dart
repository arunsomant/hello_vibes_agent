import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/core/utils/app_validator.dart';
import 'package:mingle_talk_agent/data/repositories/transaction_repository.dart';

import '../widgets/index.dart';
import 'auth_controller.dart';

class BankDetailsController extends GetxController
    with GetTickerProviderStateMixin {
  final TransactionRepository transactionRepository;

  BankDetailsController({required this.transactionRepository});

  late final ShakeController shakeControllerName = ShakeController(vsync: this);
  late final ShakeController shakeControllerBankName = ShakeController(
    vsync: this,
  );
  late final ShakeController shakeControllerAccountNumber = ShakeController(
    vsync: this,
  );
  late final ShakeController shakeControllerIFSCCode = ShakeController(
    vsync: this,
  );
  TextEditingController textEditingControllerName = TextEditingController();
  final name = ''.obs;
  TextEditingController textEditingControllerBankName = TextEditingController();
  final bankName = ''.obs;
  TextEditingController textEditingControllerAccountNumber =
      TextEditingController();
  final accountNumber = ''.obs;
  TextEditingController textEditingControllerIFSCCode = TextEditingController();
  final ifscCode = ''.obs;

  double get walletBalanceInInr =>
      Get.find<AuthController>().user.value.walletBalance;

  final busyBankDetails = false.obs;

  final busyRequest = false.obs;

  final bankDetailsAdded = false.obs;

  @override
  void onInit() {
    _getBankDetails();
    super.onInit();
  }

  void onSubmitBankDetailsPressed() {
    if (!AppValidator.validateName(textEditingControllerName.text.trim())) {
      _showToast('Please enter account holder name');
      shakeControllerName.shake();
      return;
    }
    if (!AppValidator.validateName(textEditingControllerBankName.text.trim())) {
      _showToast('Please enter a valid bank name');
      shakeControllerBankName.shake();
      return;
    }
    if (!AppValidator.validateAccountNumber(
      textEditingControllerAccountNumber.text,
    )) {
      _showToast('Please enter a valid account number');
      shakeControllerAccountNumber.shake();
      return;
    }
    if (!AppValidator.validateIFSC(textEditingControllerIFSCCode.text)) {
      _showToast('Please enter a valid IFSC code');
      shakeControllerIFSCCode.shake();
      return;
    }
    _saveBankDetails();
  }

  void _saveBankDetails() async {
    try {
      busyBankDetails(true);
      final response = await transactionRepository.updateBankDetails(
        name: textEditingControllerName.text.trim(),
        bankName: textEditingControllerBankName.text.trim(),
        accountNumber: textEditingControllerAccountNumber.text.trim(),
        ifsc: textEditingControllerIFSCCode.text.trim(),
      );
      if (response.success) {
        bankDetailsAdded(true);
        _getBankDetails();
        Get.back();
      }
      _showToast(response.message);
    } catch (_) {
      _showToast('Bank details update failed. Please try again.');
    } finally {
      busyBankDetails(false);
    }
  }

  void _getBankDetails() async {
    try {
      busyBankDetails(true);
      final response = await transactionRepository.getBankDetails();
      if (response.success) {
        bankDetailsAdded(true);
        textEditingControllerName.text = response.bankDetail.accountHolderName;
        name(response.bankDetail.accountHolderName);
        textEditingControllerBankName.text = response.bankDetail.bankName;
        bankName(response.bankDetail.bankName);
        textEditingControllerAccountNumber.text =
            response.bankDetail.accountNumber;
        accountNumber(response.bankDetail.accountNumber);
        textEditingControllerIFSCCode.text = response.bankDetail.ifscCode;
        ifscCode(response.bankDetail.ifscCode);
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Bank details update failed. Please try again.');
    } finally {
      busyBankDetails(false);
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
