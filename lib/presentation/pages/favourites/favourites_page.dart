import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/favourites_controller.dart';
import '../../widgets/hv/hv_user_tile.dart';
import '../../widgets/index.dart';
class FavouritesPage extends GetView<FavouritesController> {
  const FavouritesPage({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppText('My Vibess'),
        leading: Center(
          child: AppButtonIcon(
            svgAsset: AppAssetsMapper.icLeftArrow,
            onTap: Get.back,
            color: AppColors.iconPrimary,
          ),
        ),
      ),
      body: Obx(() {
        return ListView.separated(
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return HVUserTile(
              user: user,
              isFavourite: true,
              onAudioCallPressed: () {
                controller.onAudioCallPressed(index);
              },
              onFavouritePressed: () {
                controller.onFavouritePressed(index);
              },
              onVideoCallPressed: () {
                controller.onVideoCallPressed(index);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: AppSpacings.s8);
          },
          itemCount: controller.users.length,
        );
      }),
    );
  }
}
