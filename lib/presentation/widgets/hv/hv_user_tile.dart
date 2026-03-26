import 'package:flutter/material.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../data/models/user.dart';
import '../index.dart';

class HVUserTile extends StatelessWidget {
  const HVUserTile({
    super.key,
    required this.user,
    this.isFavourite = false,
    this.onFavouritePressed,
    this.onVideoCallPressed,
    this.onAudioCallPressed,
    this.busy = false,
  });

  final User user;

  final bool isFavourite;

  final VoidCallback? onFavouritePressed,
      onVideoCallPressed,
      onAudioCallPressed;

  final bool busy;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      enable: busy,
      child: Container(
        padding: EdgeInsets.all(AppSpacings.s12),
        decoration: BoxDecoration(
          color: AppColors.backgroundRaised,
          borderRadius: BorderRadius.circular(AppRadii.r10),
        ),
        child: Column(
          spacing: AppSpacings.s8,
          children: [
            Row(
              spacing: AppSpacings.s8,
              children: [
                ProfileImage.network(user.avatar.url, size: 56),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(user.name, type: AppTextType.t14sb, maxLine: 2),
                    AppText(
                      '${user.age}, ${user.gender}',
                      type: AppTextType.t12r,
                      maxLine: 2,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
                const Spacer(),
                if (!isFavourite)
                  user.rating == 0
                      ? AppText(
                          'New',
                          type: AppTextType.t12r,
                          color: AppColors.textPositive,
                        )
                      : StarRating(rating: user.rating, type: StarType.single)
                else
                  AppButtonIcon(
                    svgAsset: AppAssetsMapper.icHeartFill,
                    color: AppColors.iconFavourite,
                    size: 32,
                    onTap: onFavouritePressed,
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: AppSpacings.s16,
              children: [
                Expanded(
                  child: AppButton(
                    text: '2/min',
                    height: 44,
                    onPressed: onVideoCallPressed,
                    fillColor: false,
                    border: true,
                    color: AppColors.buttonPrimary,
                    textColor: AppColors.buttonPrimary,
                    prefixIconAsset: AppAssetsMapper.icCoin,
                    suffixIconAsset: AppAssetsMapper.icVideoCall,
                    applyPrefixIconColor: false,
                  ),
                ),
                Expanded(
                  child: AppButton(
                    text: '1/min',
                    height: 44,
                    onPressed: onAudioCallPressed,
                    color: AppColors.buttonPrimary,
                    textColor: AppColors.textPrimary,
                    prefixIconAsset: AppAssetsMapper.icCoin,
                    suffixIconAsset: AppAssetsMapper.icCall,
                    applySuffixIconColor: true,
                    applyPrefixIconColor: false,
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
