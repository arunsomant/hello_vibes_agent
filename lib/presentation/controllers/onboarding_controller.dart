import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/repositories/auth_repository.dart';

import '../../data/models/onboarding_content.dart';
import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  AuthRepository authRepository;

  OnboardingController({required this.authRepository});

  final content = OnboardingContent.onboardingContents();

  final currentPageIndex = 0.obs;

  final PageController pageController = PageController();

  bool get isLastPage => currentPageIndex.value == content.length - 1;

  @override
  void onInit() {
    //_gotoLogin();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _gotoLogin() {
    _saveOnboardingCompleted();
    Get.offAllNamed(AppRoutes.login);
  }

  void onPageChanged(int index) {
    currentPageIndex(index);
  }

  void onNextButtonPressed() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _gotoLogin();
    }
  }

  void onSkipPressed() {
    _gotoLogin();
  }

  void _saveOnboardingCompleted() async {
    await authRepository.saveOnboardingCompleted(true);
  }
}
