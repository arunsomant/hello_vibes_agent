import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: Stack(
            children: [
              Positioned.fill(child: AppBackground()),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacings.s40),
                  child: Column(
                    children: [
                      Expanded(child: Center(child: AppLogo())),
                      Column(
                        spacing: AppSpacings.s16,
                        children: [
                          AppText(
                            'Let\'s Hear from new people around you',
                            textAlign: TextAlign.center,
                            type: AppTextType.t24b,
                          ),
                          ShakeView(
                            controller: controller.shakeControllerMobile,
                            child: Obx(() {
                              return PhoneInputText(
                                textEditingController:
                                    controller.textEditingControllerMobile,
                                onCountryCodeSelected:
                                    controller.onCountryCodeSelected,
                                selectedCountryCode:
                                    controller.selectedCountryCode.value,
                              );
                            }),
                          ),
                          Obx(() {
                            return AppButton(
                              text: 'Get OTP',
                              onPressed: controller.onMobileLoginPressed,
                              height: 52,
                              color: AppColors.primary,
                              textColor: AppColors.textSecondary,
                              busy: controller.loginBusy.isTrue,
                            );
                          }),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: AppSpacings.s60,
                              vertical: AppSpacings.s8,
                            ),
                            child: Row(
                              spacing: AppSpacings.s8,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppColors.textPrimary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacings.s8),
                                AppText('or', type: AppTextType.t14m),
                                const SizedBox(width: AppSpacings.s8),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.textPrimary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: AppSpacings.s24,
                            children: [
                              if (!controller.isIos)
                                Expanded(
                                  child: AppButton(
                                    text: 'Continue with Google',
                                    onPressed: controller.onGoogleLoginPressed,
                                    height: 52,
                                    color: AppColors.white,
                                    textColor: AppColors.textPrimary,
                                    prefixIconAsset: AppAssetsMapper.icGoogle,
                                    applyPrefixIconColor: false,
                                  ),
                                )
                              else ...[
                                AppButtonIcon(
                                  svgAsset: AppAssetsMapper.icGoogle,
                                  onTap: controller.onGoogleLoginPressed,
                                  size: 52,
                                  backgroundColor: AppColors.white,
                                ),
                                AppButtonIcon(
                                  svgAsset: AppAssetsMapper.icApple,
                                  onTap: controller.onAppleLoginPressed,
                                  size: 52,
                                  backgroundColor: AppColors.black,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacings.s24),
                      TermsAndPrivacy(
                        onTermsPressed: controller.onTermsPressed,
                        onPolicyPressed: controller.onPolicyPressed,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
