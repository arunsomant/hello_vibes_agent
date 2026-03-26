import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_formatter.dart';
import '../../controllers/calling_controller.dart';
import '../../widgets/index.dart';

class VideoCallingPage extends GetView<CallingController> {
  const VideoCallingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onScreenTap,
      child: Scaffold(
        body: Obx(() {
          return Stack(
            children: [
              Placeholder(),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Obx(() {
                    return AppText(
                      AppFormatter.formathhmmss(controller.duration.value),
                      type: AppTextType.t14r,
                    );
                  }),
                  centerTitle: true,
                ),
              ),
              Positioned(
                right: AppSpacings.s16,
                bottom: (Get.height * controller.bottomSheetSize.value) + 16,
                child: Container(
                  height: 200,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(AppRadii.r20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: AppButtonIcon(
                          size: 44,
                          svgAsset: AppAssetsMapper.icCameraSwitch,
                          color: AppColors.iconPrimary,
                          backgroundColor: AppColors.backgroundOverlay,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
        bottomSheet: Obx(() {
          return CallControlButtonsBottonSheet(
            controller: controller.bottomSheetController,
            bottomSheetInitialSize: controller.bottomSheetInitialSize,
            bottomSheetMaximumSize: controller.bottomSheetMaximumSize.value,
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
