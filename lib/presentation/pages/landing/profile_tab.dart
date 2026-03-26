import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/index.dart';

class ProfileTab extends GetView<ProfileController> {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: false,
            actions: [
              AppButton(
                onPressed: controller.onEditPressed,
                text: 'Edit',
                textButton: true,
                textColor: AppColors.textLink,
              ),
            ],
            expandedHeight: 274,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(child: AppBackground()),
                  Center(
                    child: Obx(() {
                      final user = controller.user;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppSpacings.s60),
                          MTProfileImage(
                            user: user,
                            size: 150,
                            showOnlineStatus: false,
                          ),
                          const SizedBox(height: AppSpacings.s16),
                          AppText(user.name, type: AppTextType.t18sb),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundRaised,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadii.r10),
                  topRight: Radius.circular(AppRadii.r10),
                ),
              ),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(AppSpacings.s16),
                shrinkWrap: true,
                children: [
                  AppProfileTile(
                    onPressed: controller.onLanguagePreferencePressed,
                    assetIcon: AppAssetsMapper.icLanguage,
                    title: 'Language Preference',
                  ),
                  _buildDivider(),
                  AppProfileTile(
                    onPressed: controller.onWalletPressed,
                    assetIcon: AppAssetsMapper.icCard,
                    title: 'Wallet',
                  ),
                  _buildDivider(),
                  AppProfileTile(
                    onPressed: controller.onAccountSettingsPressed,
                    assetIcon: AppAssetsMapper.icSettings,
                    title: 'Account & Settings',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacings.s8,
        horizontal: AppSpacings.s32,
      ),
      child: Divider(height: 0, color: AppColors.borderDivider),
    );
  }
}
