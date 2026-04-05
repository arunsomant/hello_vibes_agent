import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_formatter.dart';
import '../../controllers/otp_verification_controller.dart';
import '../../widgets/index.dart';

class OtpVerificationPage extends GetView<OtpVerificationController> {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned.fill(child: AppBackground()),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacings.s20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: AppSpacings.s16,
                        children: [
                          Expanded(child: Center(child: AppLogo())),
                          const AppText(
                            'Verify Your Phone Number',
                            type: AppTextType.t16b,
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: const EdgeInsets.all(AppSpacings.s16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundRaised,
                              borderRadius: BorderRadiusGeometry.circular(
                                AppRadii.r32,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AppText(
                                  'A verification code has been sent to:',
                                  type: AppTextType.t12r,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacings.s8),
                                Obx(() {
                                  return AppText(
                                    '${controller.dialCode.value} ${controller.phoneNumber.value}',
                                    type: AppTextType.t16b,
                                    textAlign: TextAlign.center,
                                  );
                                }),
                                const SizedBox(height: AppSpacings.s16),
                                ShakeView(
                                  controller: controller.shakeControllerOtp,
                                  child: OtpWidget(
                                    controller: controller.otpController,
                                  ),
                                ),
                                const SizedBox(height: AppSpacings.s16),
                                Obx(() {
                                  return AppButton(
                                    text: 'Verify',
                                    busy: controller.otpBusy.isTrue,
                                    onPressed: controller.onVerifyPressed,
                                    height: AppSizes.appButtonHeightLarge,
                                    textColor: AppColors.textSecondary,
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacings.s24),
                          Obx(() {
                            if (controller.resendRemaining.value == 0) {
                              if (controller.isIndianNumber) {
                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: AppText.t14r.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                    children: [
                                      TextSpan(text: 'Resend Code via '),
                                      TextSpan(
                                        text: 'SMS',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap =
                                              controller.onResendSMSPressed,
                                      ),
                                      const TextSpan(text: ' or '),
                                      TextSpan(
                                        text: 'Whatsapp',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = controller
                                              .onResendWhatsappPressed,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return AppButton(
                                text: 'Resend Code',
                                textType: AppTextType.t14r,
                                textColor: AppColors.primary,
                                textButton: true,
                                height: 20,
                                padding: AppSpacings.s8,
                                onPressed: controller.otpBusy.isTrue
                                    ? null
                                    : controller.onResendCodeClicked,
                              );
                            }
                            return AppText(
                              'Resend Code in ${AppFormatter.formatHHMMSS(controller.resendRemaining.value)}',
                              type: AppTextType.t14r,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(backgroundColor: AppColors.transparent),
        ),
      ],
    );
  }
}
