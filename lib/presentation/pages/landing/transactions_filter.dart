import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/transactions_filter_controller.dart';
import '../../widgets/index.dart';

class TransactionsFilter extends GetView<TransactionsFilterController> {
  const TransactionsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s16,
          vertical: AppSpacings.s24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacings.s8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.s16,
                vertical: AppSpacings.s12,
              ),
              child: Row(
                children: [
                  Expanded(child: AppText('Filter', type: AppTextType.t16m)),
                  AppButtonIcon(
                    onTap: controller.onClosePressed,
                    svgAsset: AppAssetsMapper.icClose,
                    color: AppColors.iconPrimary,
                  ),
                ],
              ),
            ),
            AppText('Transaction Type', type: AppTextType.t14sb),
            Obx(() {
              return Wrap(
                spacing: AppSpacings.s8,
                runSpacing: AppSpacings.s8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(controller.transactionTypes.length, (
                  index,
                ) {
                  final callType = controller.transactionTypes[index];
                  final selected =
                      callType == controller.selectedTransactionType.value;
                  return AppPill(
                    text: callType.capitalizeFirst ?? '',
                    onTap: () {
                      controller.onTransactionTypeSelected(callType);
                    },
                    selected: selected,
                  );
                }),
              );
            }),

            AppText('Date Range', type: AppTextType.t14sb),
            Row(
              spacing: AppSpacings.s8,
              children: [
                Expanded(
                  child: AppInputText(
                    controller: controller.fromDateController,
                    onTap: controller.onFromDateTap,
                    label: 'From',
                    hintText: 'dd-mm-yyyy',
                  ),
                ),
                Expanded(
                  child: AppInputText(
                    controller: controller.toDateController,
                    onTap: controller.onToDateTap,
                    label: 'To',
                    hintText: 'dd-mm-yyyy',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacings.s24),
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: AppSpacings.s16,
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Clear All',
                    height: AppSizes.appButtonHeightLarge,
                    onPressed: controller.onClearAllPressed,
                    fillColor: false,
                    border: true,
                    color: AppColors.buttonPrimary,
                    textColor: AppColors.buttonPrimary,
                  ),
                ),
                Expanded(
                  child: AppButton(
                    text: 'Apply',
                    height: AppSizes.appButtonHeightLarge,
                    onPressed: controller.onApplyPressed,
                    color: AppColors.buttonPrimary,
                    textColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
