import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_formatter.dart';
import '../../../data/models/transaction.dart';
import '../../controllers/transactions_controller.dart';
import '../../widgets/index.dart';

class TransactionsTab extends GetView<TransactionsController> {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppRefreshIndicator(
        onRefresh: () async {
          controller.onRefreshPressed();
        },
        child: Obx(() {
          if (controller.busyTransactions.isFalse &&
              controller.transactions.isEmpty) {
            return AppErrorWidget(
              asset: AppAssetsMapper.listEmpty,
              message: 'No transactions found',
              onPressed: controller.onRefreshPressed,
            );
          }

          final busy = controller.busyTransactions.isTrue;
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (controller.busyTransactions.isFalse &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                controller.getNextTransactions();
              }
              return false;
            },
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacings.s16,
                horizontal: AppSpacings.s8,
              ),
              itemCount: controller.transactions.length + (busy ? 10 : 0),
              itemBuilder: (context, index) {
                Transaction transaction = const Transaction();
                if (index < controller.transactions.length) {
                  transaction = controller.transactions[index];
                  return _buildTransactionsItem(transaction: transaction);
                }
                return _buildTransactionsItem(
                  transaction: transaction,
                  busy: busy,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.s8,
                  ),
                  child: Divider(color: AppColors.borderDivider, height: 1),
                );
              },
            ),
          );
        }),
      ),
      floatingActionButton: Obx(() {
        if (controller.transactions.isNotEmpty || controller.isFilterApplied) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [AppConfig.shadow],
              borderRadius: BorderRadiusGeometry.circular(100),
            ),
            child: AppButtonIcon(
              backgroundColor: controller.isFilterApplied
                  ? AppColors.primary
                  : AppColors.backgroundRaised,
              svgAsset: AppAssetsMapper.icFilter,
              color: controller.isFilterApplied
                  ? AppColors.iconSecondary
                  : AppColors.iconPrimary,
              onTap: controller.onFilterPressed,
            ),
          );
        }
        return SizedBox();
      }),
    );
  }

  Widget _buildTransactionTypeIcon(TransactionType method) {
    String iconAsset;
    switch (method) {
      case TransactionType.voiceCall:
        iconAsset = AppAssetsMapper.icCall;
      case TransactionType.videoCall:
        iconAsset = AppAssetsMapper.icVideoCall;
      case TransactionType.adjustment:
      case TransactionType.refund:
      case TransactionType.withdrawal:
      case TransactionType.credit:
        iconAsset = AppAssetsMapper.icCard;
      case TransactionType.none:
        return SizedBox();
    }
    return AppSvgAsset(
      iconAsset,
      height: 16,
      width: 16,
      color: AppColors.iconPrimary,
    );
  }

  Widget _buildTransactionsItem({
    required Transaction transaction,
    bool busy = false,
  }) {
    return AppShimmer(
      enable: busy,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacings.s16,
          horizontal: AppSpacings.s8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: AppSpacings.s4,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacings.s4,
                          vertical: AppSpacings.s2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadii.r4),
                          color: AppColors.backgroundInputField,
                        ),
                        child: Row(
                          spacing: AppSpacings.s4,
                          children: [
                            _buildTransactionTypeIcon(transaction.type),
                            AppText(
                              transaction.type.name.capitalizeFirst ?? '',
                              type: AppTextType.t14sb,
                              dummy: busy,
                              maxDummy: 5,
                            ),
                          ],
                        ),
                      ),
                      AppText(
                        transaction.callDuration.isNotEmpty
                            ? transaction.callDuration
                            : '₹${transaction.amountInr}',
                        dummy: busy,
                        maxDummy: 5,
                      ),
                    ],
                  ),
                  AppText(
                    AppFormatter.formatDDDhhmma(transaction.createdAt),
                    type: AppTextType.t12r,
                    color: AppColors.textHint,
                    dummy: busy,
                    maxDummy: 8,
                  ),
                ],
              ),
            ),

            Row(
              children: [
                AppText(
                  '${transaction.coins}',
                  type: AppTextType.t20sb,
                  dummy: busy,
                  maxDummy: 2,
                ),
                const SizedBox(width: AppSpacings.s2),
                AppSvgAsset(AppAssetsMapper.icCoin, height: 18, width: 18),
                const SizedBox(width: AppSpacings.s8),
                AppSvgAsset(
                  transaction.direction == TransactionDirection.out
                      ? AppAssetsMapper.icArrowSend
                      : AppAssetsMapper.icArrowReceive,
                  color: transaction.direction == TransactionDirection.out
                      ? AppColors.iconDebit
                      : AppColors.iconCredit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
