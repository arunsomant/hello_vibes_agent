import 'package:flutter/material.dart';
import '../../../core/config/app_assets_mapper.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../index.dart';

class MTAppBottomBar extends StatelessWidget {
  const MTAppBottomBar({super.key, this.activeTabIndex = 0, this.onTabClicked});

  final int activeTabIndex;

  final Function(int)? onTabClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: AppColors.backgroundRaised,
        boxShadow: [AppConfig.shadow],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTabIcon(
              label: 'Calls',
              AppAssetsMapper.icCall,
              selected: activeTabIndex == 0,
              onTap: () {
                onTabClicked?.call(0);
              },
            ),
            _buildTabIcon(
              label: 'Transactions',
              AppAssetsMapper.icSwap,
              selected: activeTabIndex == 1,
              onTap: () {
                onTabClicked?.call(1);
              },
            ),
            _buildTabIcon(
              label: 'Profile',
              AppAssetsMapper.icPerson,
              selected: activeTabIndex == 2,
              onTap: () {
                onTabClicked?.call(2);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabIcon(
    String icon, {
    required bool selected,
    required VoidCallback? onTap,
    required String label,
  }) {
    return AppInkWell(
      borderRadius: AppRadii.r32,
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.none,
        constraints: BoxConstraints(minWidth: 100),
        padding: EdgeInsets.symmetric(vertical: AppSpacings.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgAsset(
              icon,
              height: 24,
              width: 24,
              color: selected ? AppColors.iconHighlight : AppColors.iconHint,
            ),
            AppText(
              label,
              type: AppTextType.t12r,
              color: selected ? AppColors.iconHighlight : AppColors.iconHint,
            ),
          ],
        ),
      ),
    );
  }
}
