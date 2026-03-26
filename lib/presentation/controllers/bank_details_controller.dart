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
  TextEditingController textEditingControllerBankName = TextEditingController();
  TextEditingController textEditingControllerAccountNumber =
      TextEditingController();
  TextEditingController textEditingControllerIFSCCode = TextEditingController();

  double get walletBalanceInInr =>
      Get.find<AuthController>().user.value.walletBalanceInInr;

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
        textEditingControllerBankName.text = response.bankDetail.bankName;
        textEditingControllerAccountNumber.text =
            response.bankDetail.accountNumber;
        textEditingControllerIFSCCode.text = response.bankDetail.ifscCode;
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Bank details update failed. Please try again.');
    } finally {
      busyBankDetails(false);
    }
  }

  void onRequestRedeemPressed() async {
    try {
      busyRequest(true);
      final coins = Get.find<AuthController>().user.value.walletBalance;
      final response = await transactionRepository.requestWithdrawal(coins: coins);
      if (response.success) {
        Get.back();
      }
      _showToast(response.message);
    } catch (_) {
      _showToast('Request failed. Please try again.');
    } finally {
      busyRequest(false);
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
