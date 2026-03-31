import'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class CallControlButtonsBottomSheet extends StatelessWidget {
  const CallControlButtonsBottomSheet({
    super.key,
    required this.controller,
    required this.bottomSheetMaximumSize,
    required this.bottomSheetInitialSize,
    required this.bottomSheetMaximumHeight,
    this.onVolumeTap,
    this.onCallEndTap,
    this.onMicTap,
    this.onVideoTap,
    this.loudSpeakerOn = false,
    this.micOn = true,
    this.videoOn = false,
    this.isVideoCall = false,
  });

  final DraggableScrollableController controller;

  final double bottomSheetMaximumSize;

  final double bottomSheetInitialSize;

  final double bottomSheetMaximumHeight;

  final VoidCallback? onVolumeTap, onCallEndTap, onMicTap, onVideoTap;

  final bool loudSpeakerOn, micOn, videoOn;

  final bool isVideoCall;

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
                  if(!isVideoCall)AppButtonIcon(
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
                  if(isVideoCall)AppButtonIcon(
                    size: 44,
                    svgAsset: videoOn
                        ? AppAssetsMapper.icVideoCall
                        : AppAssetsMapper.icVideSlash,
                    color: AppColors.iconSecondary,
                    backgroundColor: videoOn
                        ? AppColors.buttonPrimary
                        : AppColors.backgroundOverlay,
                    onTap: onVideoTap,
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
