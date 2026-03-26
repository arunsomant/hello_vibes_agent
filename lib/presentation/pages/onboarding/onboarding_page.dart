import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/onboarding_controller.dart';
import '../../widgets/index.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
           Positioned.fill(child: AppBackground()),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppSvgAsset(AppAssetsMapper.bgWhiteWave),
            ),
            SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacings.s24),
                        SizedBox(
                          height: 355,
                          child: Center(child: AppLogo()),
                        ),
                      ],
                    ),
                  ),

                  PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.content.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacings.s48,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: AppSpacings.s4,
                          children: [
                            AppText(
                              controller.content[index].title,
                              textAlign: TextAlign.center,
                              type: AppTextType.t24b,
                            ),
                            AppText(
                              controller.content[index].description,
                              type: AppTextType.t16r,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacings.s160),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.s18,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: AppSpacings.s24),
                            Obx(() {
                              return AppCarouselIndicator(
                                length: controller.content.length,
                                activeIndex:
                                    controller.currentPageIndex.value,
                              );
                            }),
                            const Spacer(),
                            Obx(() {
                              return AppButton(
                                height: AppSizes.appButtonHeightLarge,
                                text: controller.isLastPage
                                    ? 'Get Started'
                                    : 'Next',
                                onPressed: controller.onNextButtonPressed,
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: AppSpacings.s24),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: AppButton(
                      onPressed: controller.onSkipPressed,
                      text: 'Skip',
                      textButton: true,
                      textColor: AppColors.textLink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
