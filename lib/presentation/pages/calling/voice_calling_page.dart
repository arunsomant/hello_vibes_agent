import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_formatter.dart';
import '../../controllers/calling_controller.dart';
import '../../widgets/index.dart';

class VoiceCallingPage extends GetView<CallingController> {
  const VoiceCallingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onScreenTap,
      child: Scaffold(
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
                        AppFormatter.formathhmmss(controller.duration.value),
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
          return CallControlButtonsBottonSheet(
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
    );
  }
}
