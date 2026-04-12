import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/core/theme/app_colors.dart';

import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_formatter.dart';
import '../../controllers/calling_controller.dart';
import '../../widgets/index.dart';

class VoiceCallingPage extends GetView<CallingController> {
  const VoiceCallingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.backgroundPage,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          onBackButtonPressed();
        },
        child: GestureDetector(
          onTap: controller.onScreenTap,
          child: SafeArea(
            bottom: true,
            child: Scaffold(
              extendBody: true,
              body: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    title: AppText('Hello Vibess Voice Call'),
                    centerTitle: true,
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppSpacings.s20),
                          AppText(
                            controller.user.value.name,
                            type: AppTextType.t20sb,
                          ),
                          const SizedBox(height: AppSpacings.s8),
                          Obx(() {
                            return AppText(
                              AppFormatter.formathhmmss(
                                controller.duration.value,
                              ),
                              type: AppTextType.t14r,
                            );
                          }),
                          const Spacer(),
                          HVProfileImage(
                            user: controller.user.value,
                            size: 150,
                            showOnlineStatus: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(height: controller.bottomSheetMaximumHeight),
                ],
              ),
              bottomSheet: Obx(() {
                return CallControlButtonsBottomSheet(
                  controller: controller.bottomSheetController,
                  bottomSheetMaximumSize: controller.bottomSheetMaximumSize.value,
                  bottomSheetInitialSize: controller.bottomSheetInitialSize,
                  bottomSheetMaximumHeight: controller.bottomSheetMaximumHeight,
                  onVolumeTap: controller.onVolumeTap,
                  onCallEndTap: controller.onCallEndTap,
                  onMicTap: controller.onMicTap,
                  loudSpeakerOn: controller.loudSpeakerOn.value,
                  micOn: controller.micOn.value,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void onBackButtonPressed() {
    AppDialog.showAlertDialog(
      negativeText: 'Yes, Disconnect',
      positiveText: 'Cancel',
      title:
          'This will disconnect the ongoing call. Are you sure want to end the call ?',
      textHeight: 50,
      positiveOnPressed: () {
        Get.back();
      },
      negativeOnPressed: () {
        Get.back();
        controller.onCallEndTap();
      },
    );
  }
}
