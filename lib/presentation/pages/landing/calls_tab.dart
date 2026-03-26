import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_assets_mapper.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_formatter.dart';
import '../../../data/models/call.dart';
import '../../controllers/calls_controller.dart';
import '../../widgets/index.dart';

class CallsTab extends GetView<CallsController> {
  const CallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppRefreshIndicator(
        onRefresh: () async {
          controller.onRefresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverFloatingHeader(
              snapMode: FloatingHeaderSnapMode.scroll,
              child: Center(
                child: ColoredBox(
                  color: AppColors.backgroundPage,
                  child: _buildWallerBanner(),
                ),
              ),
            ),
            Obx(() {
              if (controller.busyCalls.isFalse && controller.calls.isEmpty) {
                return SliverFillRemaining(
                  child: AppErrorWidget(
                    asset: AppAssetsMapper.icDocumentText,
                    onPressed: controller.onRefresh,
                    message: 'Empty list',
                  ),
                );
              }
              final busy = controller.busyCalls.isTrue;

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s16),
                sliver: SliverList.separated(
                  itemCount: controller.calls.length + (busy ? 5 : 0),
                  itemBuilder: (context, index) {
                    Call call = const Call();
                    if (index < controller.calls.length) {
                      call = controller.calls[index];
                    }
                    return _buildCallItem(call: call, busy: busy);
                  },
                  separatorBuilder: (context, index) {
                    return _buildCallDivider();
                  },
                ),
              );
            }),
            SliverToBoxAdapter(child: const SizedBox(height: AppSpacings.s160)),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
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
      }),
    );
  }

  Widget _buildWallerBanner() {
    return Container(
      height: 100,
      margin: EdgeInsets.all(AppSpacings.s16),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(AppRadii.r20),
      ),
      clipBehavior: Clip.hardEdge,
      child: AppInkWell(
        onTap: controller.onWalletBannerPressed,
        child: Stack(
          children: [
            Positioned.fill(
              child: AppAssetImage(AppAssetsMapper.backgroundCoins),
            ),
            Center(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: AppSpacings.s24,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return AppText(
                            '₹${controller.walletBalance}',
                            type: AppTextType.t24sb,
                            color: Colors.white,
                          );
                        }),
                        AppText(
                          'Wallet Balance',
                          type: AppTextType.t14r,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    AppSvgAsset(
                      AppAssetsMapper.icRightArrow,
                      color: AppColors.iconSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallItem({required Call call, bool busy = false}) {
    return AppShimmer(
      enable: busy,
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.s12),
        child: Column(
          spacing: AppSpacings.s8,
          children: [
            Row(
              spacing: AppSpacings.s8,
              children: [
                ProfileImage.network(call.participant.avatar.url, size: 56),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: AppText(
                              call.participant.name,
                              type: AppTextType.t14sb,
                              maxLine: 2,
                              dummy: busy,
                              maxDummy: 5,
                            ),
                          ),
                          const SizedBox(width: AppSpacings.s4),
                          AppSvgAsset(
                            call.type == CallType.video
                                ? AppAssetsMapper.icVideoCall
                                : AppAssetsMapper.icCall,
                            height: 16,
                            width: 16,
                            color: AppColors.iconPrimary,
                          ),
                        ],
                      ),
                      AppText(
                        AppFormatter.formatDDDhhmma(call.initiatedAt),
                        type: AppTextType.t12r,
                        maxLine: 2,
                        color: AppColors.textHint,
                        dummy: busy,
                        maxDummy: 4,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      call.duration,
                      type: AppTextType.t12r,
                      maxLine: 2,
                      dummy: busy,
                      maxDummy: 3,
                    ),
                    Row(
                      children: [
                        AppText(
                          '${call.coins}',
                          type: AppTextType.t12r,
                          maxLine: 2,
                          color: AppColors.textError,
                          dummy: busy,
                          maxDummy: 2,
                        ),
                        const SizedBox(width: AppSpacings.s2),
                        AppSvgAsset(
                          AppAssetsMapper.icCoin,
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallDivider() {
    return Divider(height: 1, color: AppColors.borderDivider);
  }
}
