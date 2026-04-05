import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../data/models/call.dart';
import '../../controllers/rating_controller.dart';
import '../../widgets/index.dart';

class RatingDialogArguments {
  final Call call;

  RatingDialogArguments({required this.call});
}

class RatingDialog extends GetView<RatingController> {
  const RatingDialog({super.key});

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
          final user = controller.call.value.participant;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.selectedReport.isTrue
                  ? _buildReport()
                  : Column(
                      spacing: AppSpacings.s4,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          'How Was Your Experience With',
                          type: AppTextType.t16m,
                        ),
                        HVProfileImage(
                          user: user,
                          size: 100,
                          showOnlineStatus: false,
                        ),
                        AppText(user.name, type: AppTextType.t20sb, maxLine: 2),
                      ],
                    ),
              const SizedBox(height: AppSpacings.s16),
              AnimatedSize(
                duration: Duration(milliseconds: 200),
                child: Column(
                  children: [
                    AppButton(
                      fillColor: false,
                      border: true,
                      busy: controller.busy.isTrue,
                      textColor: AppColors.buttonPrimary,
                      prefixIconAsset: AppAssetsMapper.icHorn,
                      height: AppSizes.appButtonHeightLarge,
                      text: controller.selectedReport.isTrue
                          ? 'Submit Report'
                          : 'Report',
                      onPressed: controller.selectedReport.isTrue
                          ? controller.onSubmitReportPressed
                          : controller.onReportPressed,
                    ),
                    const SizedBox(height: AppSpacings.s16),
                  ],
                ),
              ),
              AppButton(
                height: AppSizes.appButtonHeightLarge,
                text: 'Feeling Good',
                onPressed: controller.onFeelingGoodPressed,
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
        Center(child: AppText('More About Your Experience', type: AppTextType.t14m)),
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
