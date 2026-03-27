import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class CallControlButtonsBottonSheet extends StatelessWidget {
  const CallControlButtonsBottonSheet({
    super.key,
    required this.controller,
    required this.bottomSheetMaximumSize,
    required this.bottomSheetInitialSize,
    required this.bottomSheetMaximumHeight,
    this.onVolumeTap,
    this.onCallEndTap,
    this.onMicTap,
    this.loudSpeakerOn = false,
    this.micOn = true,
  });

  final DraggableScrollableController controller;

  final double bottomSheetMaximumSize;

  final double bottomSheetInitialSize;

  final double bottomSheetMaximumHeight;

  final VoidCallback? onVolumeTap, onCallEndTap, onMicTap;

  final bool loudSpeakerOn, micOn;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      expand: false,
      initialChildSize: bottomSheetMaximumSize,
      minChildSize: bottomSheetInitialSize,
      maxChildSize: bottomSheetMaximumHeight / Get.height,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s60),
          decoration: BoxDecoration(
            color: AppColors.backgroundInputField,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadii.r20),
              topRight: Radius.circular(AppRadii.r20),
            ),
          ),

          child: SingleChildScrollView(
            controller: scrollController,
            physics: ClampingScrollPhysics(),
            child: SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButtonIcon(
                    size: 44,
                    svgAsset: loudSpeakerOn
                        ? AppAssetsMapper.icVolume
                        : AppAssetsMapper.icVolumeSlash,
                    color: AppColors.iconSecondary,
                    backgroundColor: loudSpeakerOn
                        ? AppColors.buttonPrimary
                        : AppColors.backgroundOverlay,
                    onTap: onVolumeTap,
                  ),
                  AppButtonIcon(
                    size: 56,
                    svgAsset: AppAssetsMapper.icCallDown,
                    color: AppColors.iconSecondary,
                    backgroundColor: AppColors.red,
                    sizeIcon: 36,
                    onTap: onCallEndTap,
                  ),
                  AppButtonIcon(
                    size: 44,
                    svgAsset: micOn
                        ? AppAssetsMapper.icMic
                        : AppAssetsMapper.icMicOff,
                    color: AppColors.iconSecondary,
                    backgroundColor: micOn
                        ? AppColors.buttonPrimary
                        : AppColors.backgroundOverlay,
                    onTap: onMicTap,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
