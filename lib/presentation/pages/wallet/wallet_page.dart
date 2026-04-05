import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/wallet_controller.dart';
import '../../widgets/index.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          bottom: 500,
          child: AppBackground(backgroundColor: AppColors.macaroniDark),
        ),
        Scaffold(
          backgroundColor: AppColors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            title: AppText('Wallet', color: AppColors.textSecondary),
            centerTitle: false,
            leading: Center(
              child: AppButtonIcon(
                svgAsset: AppAssetsMapper.icLeftArrow,
                onTap: Get.back,
                color: AppColors.iconSecondary,
              ),
            ),
            actions: [
              AppButtonIcon(
                svgAsset: AppAssetsMapper.icFAQ,
                onTap: Get.back,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverFloatingHeader(
                snapMode: FloatingHeaderSnapMode.scroll,
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: AppSpacings.s16,
                    vertical: AppSpacings.s16,
                  ),
                  child: Row(
                    spacing: AppSpacings.s8,
                    children: [
                      AppText(
                        '₹',
                        type: AppTextType.t64b,
                        shadow: true,
                        color: AppColors.textSecondary,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              controller.walletBalanceInInr.toStringAsFixed(2),
                              type: AppTextType.t40b,
                              shadow: true,
                              color: AppColors.textSecondary,
                            ),
                            AppText(
                              'Wallet Balance',
                              type: AppTextType.t14sb,
                              shadow: true,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      AppInkWell(
                        borderRadius: AppRadii.r8,
                        onTap: controller.onTransactionHistoryPressed,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacings.s4),
                          child: AppText(
                            'Transaction History',
                            type: AppTextType.t12sb,
                            decoration: TextDecoration.underline,
                            color: AppColors.textSecondary,
                            shadow: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Container(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: AppSpacings.s16,
                    vertical: AppSpacings.s8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundRaised,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppRadii.r32),
                      topRight: Radius.circular(AppRadii.r32),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacings.s32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSpacings.s8,
                          children: [
                            AppText('Your Wallet', type: AppTextType.t16b),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacings.s16,
                                vertical: AppSpacings.s24,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundRaised,
                                boxShadow: [AppConfig.shadow],
                                borderRadius: BorderRadius.circular(
                                  AppRadii.r10,
                                ),
                              ),
                              child: Obx( () {
                                  return Column(
                                    spacing: AppSpacings.s8,
                                    children: [
                                      _buildInfoRow(
                                        label: 'Redeemable Coins:',
                                        value: '${controller.walletBalance}',
                                      ),
                                      Divider(),
                                      _buildInfoRow(
                                        label: 'Redeemable Amount:',
                                        value: '₹${controller.walletBalanceInInr}',
                                      ),
                                      Divider(),
                                      _buildInfoRow(
                                        label: 'Lifetime Earnings',
                                        value:
                                            '₹${controller.lifetimeEarningsInInr}',
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          if (controller.bankDetailsAdded) {
                            return _buildBankDetailsSection();
                          }
                          return SizedBox();
                        }),
                        Spacer(),
                        Obx(() {
                          return AppButton(
                            busy: controller.busyRequest.isTrue,
                            prefixIconAsset: AppAssetsMapper.icCard,
                            prefixIconColor: AppColors.iconSecondary,
                            text:
                                'Request to Redeem ₹${controller.walletBalanceInInr.toStringAsFixed(2)}',
                            onPressed: controller.walletBalance > 0
                                ? onRequestRedeemPressed
                                : null,
                            height: AppSizes.appButtonHeightLarge,
                          );
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
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      spacing: AppSpacings.s8,
      children: [
        Expanded(child: AppText(label, type: AppTextType.t14r)),
        AppText(value, type: AppTextType.t14sb),
      ],
    );
  }

  void onRequestRedeemPressed() {
    if (controller.bankDetailsAdded) {
      AppDialog.showAlertDialog(
        positiveText: 'Redeem Now',
        negativeText: 'Cancel',
        title: 'Are you sure you want to redeem your wallet?',
        textHeight: 50,
        negativeOnPressed: () {
          Get.back();
        },
        positiveOnPressed: () {
          Get.back();
          controller.onRequestRedeemPressed();
        },
      );
    } else {
      AppDialog.showAlertDialog(
        positiveText: 'Add Bank Details',
        negativeText: 'Cancel',
        title: 'Please add your bank details to redeem your wallet balance.',
        textHeight: 50,
        negativeOnPressed: () {
          Get.back();
        },
        positiveOnPressed: () {
          Get.back();
          controller.onEditBankDetailsPressed();
        },
      );
    }
  }

  Widget _buildBankDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacings.s8,
      children: [
        SizedBox(height: AppSpacings.s8),
        Row(
          children: [
            AppText('Bank Details', type: AppTextType.t16b),
            Spacer(),
            AppInkWell(
              borderRadius: AppRadii.r8,
              onTap: controller.onEditBankDetailsPressed,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.s4),
                child: AppText(
                  'Edit',
                  type: AppTextType.t14r,
                  decoration: TextDecoration.underline,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacings.s16,
            vertical: AppSpacings.s24,
          ),
          decoration: BoxDecoration(
            color: AppColors.backgroundRaised,
            boxShadow: [AppConfig.shadow],
            borderRadius: BorderRadius.circular(AppRadii.r10),
          ),
          child: Column(
            spacing: AppSpacings.s8,
            children: [
              _buildInfoRow(label: 'Name:', value: controller.name),
              Divider(),
              _buildInfoRow(label: 'Bank Name:', value: controller.bankName),
              Divider(),
              _buildInfoRow(
                label: 'Account Number:',
                value: controller.accountNumber,
              ),
              Divider(),
              _buildInfoRow(label: 'IFSC Code:', value: controller.ifscCode),
            ],
          ),
        ),
      ],
    );
  }
}
