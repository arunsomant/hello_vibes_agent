import 'package:flutter/material.dart';
import 'package:mingle_talk_agent/core/config/app_config.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../data/models/user.dart';
import '../index.dart';

class MTProfileImage extends StatelessWidget {
  const MTProfileImage({
    super.key,
    required this.user,
    this.size = 100,
    this.showOnlineStatus = true,
    this.shadow = false,
  });

  final User user;

  final double size;

  final bool showOnlineStatus;

  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(AppSpacings.s8),
      decoration: BoxDecoration(
        color: AppColors.backgroundRaised,
        borderRadius: BorderRadius.circular(AppRadii.r32),
        boxShadow: shadow? [AppConfig.shadow]: null,
      ),
      child: ProfileImage.network(user.avatar.url,size:size,radius:  AppRadii.r32 - AppSpacings.s8,),
    );
  }
}
