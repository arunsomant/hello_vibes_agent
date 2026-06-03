import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_formatter.dart';
import '../../../data/models/call.dart';
import '../../controllers/calling_controller.dart';
import '../../widgets/index.dart';

class VideoCallingPage extends GetView<CallingController> {
  const VideoCallingPage({super.key});

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
          child: Scaffold(
            extendBody: true,
            body: Obx(() {
              return Stack(
                children: [
                  if (controller.participantVideoEnabled.isTrue)
                    Positioned.fill(
                      child: Obx(() {
                        Widget videoTrackWidget = SizedBox();
                        final participant = controller.participant.value;
                        final videoTrack = participant
                            ?.videoTrackPublications
                            .firstOrNull
                            ?.track;
                        if (videoTrack != null) {
                          videoTrackWidget = VideoTrackRenderer(
                            videoTrack,
                            fit: VideoViewFit.cover,
                          );
                        }
                        return videoTrackWidget;
                      }),
                    ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: SafeArea(
                      bottom: true,
                      child: Column(
                        children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            title: Obx(() {
                              if (controller.callStatus.value ==
                                  CallStatus.initiated) {
                                return AppText(
                                  'Connecting...',
                                  type: AppTextType.t14r,
                                );
                              } else if (controller.callStatus.value ==
                                  CallStatus.ringing) {
                                return AppText(
                                  'Ringing...',
                                  type: AppTextType.t14r,
                                );
                              } else if (controller.callStatus.value ==
                                  CallStatus.rejected) {
                                return AppText(
                                  'Call Rejected',
                                  type: AppTextType.t14r,
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    AppFormatter.formathhmmss(
                                      controller.duration.value,
                                    ),
                                    type: AppTextType.t14r,
                                  ),
                                  if (controller.callStatus.value ==
                                      CallStatus.ended)
                                    AppText(
                                      'Call Ended',
                                      type: AppTextType.t14r,
                                    ),
                                ],
                              );
                            }),
                            centerTitle: true,
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: AppSpacings.s20),
                                  if (controller
                                      .participantVideoEnabled
                                      .isFalse)
                                    AppText(
                                      controller.user.value.name,
                                      type: AppTextType.t20sb,
                                    ),
                                  const SizedBox(height: AppSpacings.s8),
                                  const Spacer(),
                                  if (controller
                                      .participantVideoEnabled
                                      .isFalse)
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
                    ),
                  ),
                  Positioned(
                    right: AppSpacings.s16,
                    bottom:
                        (Get.height * controller.bottomSheetSize.value) + 16,
                    child: SafeArea(
                      bottom: true,
                      child: Container(
                        height: 200,
                        width: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(AppRadii.r20),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Obx(() {
                                Widget localVideoTrackWidget = SizedBox();
                                final localParticipant =
                                    controller.localParticipant.value;
                                final localVideoTrack = localParticipant
                                    ?.videoTrackPublications
                                    .firstOrNull
                                    ?.track;
                                if (localVideoTrack != null) {
                                  localVideoTrackWidget = VideoTrackRenderer(
                                    localVideoTrack,
                                    fit: VideoViewFit.cover,
                                  );
                                }
                                return localVideoTrackWidget;
                              }),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: AppButtonIcon(
                                size: 44,
                                svgAsset: AppAssetsMapper.icCameraSwitch,
                                color: AppColors.iconSecondary,
                                backgroundColor: AppColors.backgroundOverlay,
                                onTap: controller.onFlipCameraTap,
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: AppButtonIcon(
                                size: 44,
                                svgAsset: controller.videoOn.isTrue
                                    ? AppAssetsMapper.icVideoCall
                                    : AppAssetsMapper.icVideSlash,
                                color: AppColors.iconSecondary,
                                backgroundColor: controller.videoOn.isTrue
                                    ? AppColors.backgroundOverlay
                                    : AppColors.buttonDisabled,
                                onTap: controller.onVideoTap,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            bottomSheet: Obx(() {
              return CallControlButtonsBottomSheet(
                controller: controller.bottomSheetController,
                bottomSheetInitialSize: controller.bottomSheetInitialSize,
                bottomSheetMaximumSize: controller.bottomSheetMaximumSize.value,
                bottomSheetMaximumHeight: controller.bottomSheetMaximumHeight,
                onVolumeTap: controller.onVolumeTap,
                onCallEndTap: controller.onCallEndTap,
                onMicTap: controller.onMicTap,
                loudSpeakerOn: controller.loudSpeakerOn.value,
                micOn: controller.micOn.value,
                videoOn: controller.videoOn.value,
                isVideoCall: true,
              );
            }),
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
