import 'dart:io';

import 'package:deep_country_code_picker/deep_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../pages/policy/policy_page.dart';
import '../routes/app_routes.dart';
import '../widgets/index.dart';
import 'auth_controller.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  LoginController({required this.authRepository});

  final AuthRepository authRepository;

  TextEditingController textEditingControllerMobile = TextEditingController();

  late final shakeControllerMobile = ShakeController(vsync: this);

  final loginBusy = false.obs;

  final selectedCountryCode = '+91'.obs;

  final isIos = Platform.isIOS || Platform.isMacOS;

  @override
  void onClose() {
    textEditingControllerMobile.dispose();
    shakeControllerMobile.dispose();
    super.onClose();
  }

  void onMobileLoginPressed() {
    final mobile = textEditingControllerMobile.text.trim().removeAllWhitespace;

    if (!CountryCodePicker.validateMobile(
      '${selectedCountryCode.value}$mobile',
    )) {
      shakeControllerMobile.shake();
      _showToast('Enter a valid phone number');
      return;
    }
    _sendOtp(mobile: mobile, countryCode: selectedCountryCode.value);
  }

  void onGoogleLoginPressed() {
    Get.find<AuthController>().signInWithGoogle();
  }

  void onAppleLoginPressed() {
    _gotoProfileSetupPage();
  }

  void _gotoProfileSetupPage() {
    Get.offAllNamed(AppRoutes.profileSetup);
  }

  void onCountryCodeSelected(Country country) {
    selectedCountryCode(country.dialCode);
  }

  void _sendOtp({required String mobile, required String countryCode}) async {
    try {
      loginBusy(true);
      final response = await authRepository.sendOtp(
        mobile: mobile.removeAllWhitespace,
        countryCode: countryCode,
      );
      if (response.success) {
        _gotoOtpVerificationPage(mobile: mobile, countryCode: countryCode);
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Something went wrong!');
    } finally {
      loginBusy(false);
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }

  void _gotoOtpVerificationPage({
    required String mobile,
    required String countryCode,
  }) {
    Get.toNamed(
      AppRoutes.otpVerification,
      arguments: {'mobile': mobile, 'countryCode': countryCode},
    );
  }

  void onTermsPressed() {
    _gotoTermsPage();
  }

  void onPolicyPressed() {
    _gotoPolicyPage();
  }

  void _gotoTermsPage() {
    Get.toNamed(
      AppRoutes.policy,
      arguments: PolicyArguments.termsAndConditions(),
    );
  }

  void _gotoPolicyPage() {
    Get.toNamed(AppRoutes.policy, arguments: PolicyArguments.privacyPolicy());
  }
}
