import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/otp.dart';
import '../../data/repositories/auth_repository.dart';
import '../pages/login/otp_verification_page.dart';
import '../widgets/index.dart';
import 'auth_controller.dart';

class OtpVerificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  OtpVerificationController({required this.authRepository});

  final AuthRepository authRepository;

  final TextEditingController otpController = TextEditingController();

  late final ShakeController shakeControllerOtp = ShakeController(vsync: this);

  final phoneNumber = ''.obs;

  final dialCode = ''.obs;

  final otpBusy = false.obs;

  late final resendRemaining = 0.obs;

  late Timer _timer;

  final int timerDuration2 = 180;

  final int timerDuration1 = 60;

  final availableProviders = <OtpProviderType>[].obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is OtpVerificationArgs) {
      phoneNumber(arguments.mobile);
      dialCode(arguments.countryCode);
      availableProviders(arguments.availableProviders);
    }
    startTimer(timerDuration1);
    otpController.addListener(() {
      if (otpController.text.trim().length == 4) {
        onVerifyPressed();
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    shakeControllerOtp.dispose();
    otpController.dispose();
    super.dispose();
  }

  void startTimer(int duration) {
    resendRemaining(duration);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendRemaining.value > 0) {
        resendRemaining.value--;
      } else {
        _timer.cancel();
      }
    });
  }

  void onVerifyPressed() {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      shakeControllerOtp.shake();
      _showToast('Enter OTP');
      return;
    }
    _verifyOtp(
      otp: otp,
      mobile: phoneNumber.value,
      countryCode: dialCode.value,
    );
  }

  void onResendSMSPressed() {
    _resendOtp(
      mobile: phoneNumber.value,
      countryCode: dialCode.value,
      providerType: OtpProviderType.sms,
    );
  }

  void onResendWhatsappPressed() {
    _resendOtp(
      mobile: phoneNumber.value,
      countryCode: dialCode.value,
      providerType: OtpProviderType.whatsapp,
    );
  }

  void onResendCodeClicked() {
    _resendOtp(mobile: phoneNumber.value, countryCode: dialCode.value);
  }

  void _resendOtp({
    required String mobile,
    required String countryCode,
    OtpProviderType? providerType,
  }) async {
    try {
      otpBusy(true);
      final response = await authRepository.sendOtp(
        mobile: mobile.removeAllWhitespace,
        countryCode: countryCode,
        providerType: providerType,
      );
      if (response.success) {
        availableProviders(response.availableProviders);
        startTimer(timerDuration2);
        _showToast(response.message + response.otp);
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Something went wrong!');
    } finally {
      otpBusy(false);
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }

  void _verifyOtp({
    required String otp,
    required String mobile,
    required String countryCode,
  }) async {
    try {
      otpBusy(true);
      final response = await authRepository.verifyOtp(
        otp: otp,
        mobile: mobile.removeAllWhitespace,
        countryCode: countryCode,
      );
      if (response.success) {
        await authRepository.saveAccessToken(response.loginData.token);
        if (Get.isRegistered<AuthController>()) {
          Get.find<AuthController>().gotoLandingPage();
        }
      } else {
        shakeControllerOtp.shake();
        _showToast(response.message);
      }
    } catch (e) {
      _showToast('Something went wrong!');
    } finally {
      otpBusy(false);
    }
  }
}
