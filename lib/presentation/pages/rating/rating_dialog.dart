import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../data/models/user.dart';
import '../../controllers/rating_controller.dart';
import '../../widgets/index.dart';

class RatingDialog extends GetView<RatingController> {
  const RatingDialog({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s16,
          vertical: AppSpacings.s24,
        ),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                spacing: AppSpacings.s4,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText('Rate Your Experience With', type: AppTextType.t16m),
                  HVProfileImage(
                    user: user,
                    size: 100,
                    showOnlineStatus: false,
                  ),
                  AppText(user.name, type: AppTextType.t20sb, maxLine: 2),
                  StarRating(
                    rating: controller.rating.value,
                    onRatingPressed: controller.onRatingPressed,
                    showRatingValue: false,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacings.s16),
              AnimatedSize(
                duration: Duration(milliseconds: 200),
                child: controller.rating >= 3
                    ? Column(
                        children: [
                          AppButton(
                            fillColor: false,
                            border: true,
                            textColor: AppColors.buttonPrimary,
                            prefixIconAsset: controller.addedToFavourite.isTrue
                                ? AppAssetsMapper.icHeartFill
                                : AppAssetsMapper.icHeart,
                            prefixIconColor: controller.addedToFavourite.isTrue
                                ? AppColors.iconFavourite
                                : AppColors.buttonPrimary,
                            height: AppSizes.appButtonHeightLarge,
                            text: 'Add to Vibess',
                            onPressed: controller.rating > 0
                                ? controller.onAddToFavouritePressed
                                : null,
                          ),
                          const SizedBox(height: AppSpacings.s16),
                        ],
                      )
                    : controller.rating > 0
                    ? _buildReport()
                    : SizedBox.shrink(),
              ),
              AppButton(
                height: AppSizes.appButtonHeightLarge,
                text: 'Submit',
                onPressed: controller.rating > 0
                    ? controller.onSubmitPressed
                    : null,
              ),
              const SizedBox(height: AppSpacings.s24),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildReport() {
    return Column(
      spacing: AppSpacings.s8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('More About You Experience', type: AppTextType.t14m),
        ...List.generate(controller.reportOptions.length, (index) {
          return _buildReportTile(
            title: controller.reportOptions[index],
            selected: controller.selectedReportOption.value == index,
            onPressed: () {
              controller.onReportItemPressed(index);
            },
          );
        }),
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: controller.showReportCommentInput
              ? AppInputText(
                  height: 110,
                  textAlign: TextAlign.start,
                  maxLines: 5,
                  hintText: 'Enter Here',
                )
              : SizedBox.shrink(),
        ),

        const SizedBox(height: AppSpacings.s16),
      ],
    );
  }

  Widget _buildReportTile({
    required String title,
    required bool selected,
    VoidCallback? onPressed,
  }) {
    return Row(
      spacing: AppSpacings.s8,
      children: [
        AppRadioButton(selected: selected, onPressed: onPressed),
        AppText(title, type: AppTextType.t14r),
      ],
    );
  }
}
