import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../data/models/user.dart';
import '../../controllers/profile_review_controller.dart';
import '../../widgets/index.dart';

class ProfileReviewPage extends GetView<ProfileReviewController> {
  const ProfileReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackground(),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: AppColors.transparent,
                  actions: [
                    AppButtonIcon(
                      svgAsset: AppAssetsMapper.icSettings,
                      onTap: controller.onSettingsPressed,
                      color: AppColors.iconPrimary,
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.s16,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Obx(() {
                              final pending =
                                  controller.approvalStatus.value ==
                                  ApprovalStatus.pending;
                              return Column(
                                children: [
                                  const SizedBox(height: AppSpacings.s60),
                                  AppSvgAsset(
                                    AppAssetsMapper.icDocSearch,
                                    height: 85,
                                    width: 85,
                                  ),
                                  const SizedBox(height: AppSpacings.s4),
                                  Container(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: AppSpacings.s4,
                                      vertical: AppSpacings.s2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: pending
                                          ? AppColors.macaroni
                                          : AppColors.red,
                                      borderRadius: BorderRadius.circular(
                                        AppRadii.r4,
                                      ),
                                    ),
                                    child: Row(
                                      spacing: AppSpacings.s2,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppSvgAsset(
                                          pending
                                              ? AppAssetsMapper.icTime
                                              : AppAssetsMapper.icAlert,
                                          height: 16,
                                          width: 16,
                                        ),
                                        AppText(
                                          pending
                                              ? 'Pending Review'
                                              : 'Verification Unsuccessful',
                                          type: AppTextType.t14sb,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacings.s8),
                                  AppText(
                                    pending
                                        ? controller.pendingTitle
                                        : controller.rejectedTitle,
                                    type: AppTextType.t24b,
                                    textAlign: TextAlign.center,
                                  ),
                                  AppText(
                                    pending
                                        ? controller.pendingContent
                                        : controller.rejectedContent,
                                    type: AppTextType.t16m,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: AppSpacings.s24),
                                ],
                              );
                            }),
                          ),
                          Obx(() {
                            if (controller.approvalStatus.value ==
                                ApprovalStatus.pending) {
                              return AppButton(
                                text: 'Close',
                                onPressed: controller.onClosePressed,
                                height: AppSizes.appButtonHeightLarge,
                              );
                            }
                            if (controller.approvalStatus.value ==
                                ApprovalStatus.rejected) {
                              return AppButton(
                                text: 'Update Profile',
                                onPressed: controller.onUpdateProfilePressed,
                                height: AppSizes.appButtonHeightLarge,
                              );
                            }
                            return SizedBox();
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
