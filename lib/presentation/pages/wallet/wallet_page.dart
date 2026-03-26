import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/core/config/app_config.dart';

import '../../../core/config/app_assets_mapper.dart';
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
        Positioned.fill(child: AppBackground()),
        Scaffold(
          backgroundColor: AppColors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            title: AppText('Wallet'),
            centerTitle: false,
            leading: Center(
              child: AppButtonIcon(
                svgAsset: AppAssetsMapper.icLeftArrow,
                onTap: Get.back,
                color: AppColors.iconPrimary,
              ),
            ),
            actions: [
              AppButtonIcon(
                svgAsset: AppAssetsMapper.icFAQ,
                onTap: Get.back,
                color: AppColors.iconPrimary,
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
                      AppText('₹', type: AppTextType.t64b, shadow: true),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              controller.walletBalanceInInr.toStringAsFixed(2),
                              type: AppTextType.t40b,
                              shadow: true,
                            ),
                            AppText(
                              'Wallet Balance',
                              type: AppTextType.t14sb,
                              shadow: true,
                            ),
                          ],
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
                              child: Column(
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
                                    value: '₹${controller.lifetimeEarningsInInr}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        AppButton(
                          prefixIconAsset: AppAssetsMapper.icCard,
                          prefixIconColor: AppColors.iconSecondary,
                          text:
                              'Request to Redeem ₹${controller.walletBalanceInInr.toStringAsFixed(2)}',
                          onPressed: controller.onRequestRedeemPressed,
                          height: AppSizes.appButtonHeightLarge,
                        ),
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
}
