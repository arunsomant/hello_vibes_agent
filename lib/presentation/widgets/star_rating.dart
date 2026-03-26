import 'package:flutter/material.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

enum StarType { single, multiple }

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.ratingCount,
    this.type = StarType.multiple,
    this.suffixText = '',
    this.showRatingValue = true,
    this.iconSize,
    this.onRatingPressed,
  });

  final double rating;

  final double? iconSize;

  final int? ratingCount;

  final StarType type;

  final String suffixText;

  final bool showRatingValue;

  final Function(double value)? onRatingPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type == StarType.multiple)
          ...List.generate(
            5,
            (index) => AppInkWell(
              borderRadius: AppRadii.r8,
              onTap: onRatingPressed != null
                  ? () {
                      onRatingPressed?.call(index + 1);
                    }
                  : null,
              child: _buildStar(index, rating),
            ),
          )
        else
          _buildStar((5 - rating).round() - 1, rating),
        const SizedBox(width: AppSpacings.s4),
        AppText(
          '${showRatingValue ? rating : ''}${ratingCount != null ? ' ($ratingCount)' : ''}${suffixText.isNotEmpty ? ' $suffixText' : ''}',
          type: AppTextType.t12r,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }

  Widget _buildStar(int index, double rating) {
    final iconSize =
        this.iconSize ??
        (type == StarType.single
            ? AppSizes.ratingStarSizeSmall
            : AppSizes.ratingStarSize);
    return AppSvgAsset(
      index >= rating
          ? AppAssetsMapper.icStar
          : index > rating - 1 && index < rating
          ? AppAssetsMapper.icStarHalf
          : AppAssetsMapper.icStarFilled,
      height: iconSize,
      width: iconSize,
    );
  }
}
