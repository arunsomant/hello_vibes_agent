import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/profile_setup_controller.dart';
import '../../widgets/index.dart';

class ProfileEditPage extends GetView<ProfileSetupController> {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          Positioned.fill(child: AppBackground()),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: AppText('Profile Edit'),
              backgroundColor: Colors.transparent,
            ),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  scrolledUnderElevation: 10,
                  automaticallyImplyLeading: false,
                  floating: false,
                  pinned: true,
                  primary: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: 224,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppSpacings.s8,
                      children: [
                        const SizedBox(height: AppSpacings.s4),
                        SizedBox(
                          height: AppSizes.avatarCarouselHeight + 32,
                          child: Obx(() {
                            if (controller.avatarsBusy.isTrue) {
                              return AppText(
                                'Fetching Avatars...',
                                type: AppTextType.t14m,
                              );
                            }
                            if (controller.avatarList.isEmpty) {
                              return AppErrorWidget(
                                message: 'Failed to load avatars',
                                onPressed: controller.getAvatarList,
                              );
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: AppSpacings.s8,
                              children: [
                                AppText(
                                  'Select Your Avatar',
                                  type: AppTextType.t14m,
                                ),
                                AppProfileSelectionCarousel(
                                  avatarList: controller.avatarList.value,
                                  onAvatarChanged: controller.onAvatarChanged,
                                  selectedAvatar:
                                      controller.selectedAvatar.value,
                                ),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacings.s16,
                      vertical: AppSpacings.s24,
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
                        spacing: AppSpacings.s16,
                        children: [
                          ShakeView(
                            controller: controller.shakeControllerName,
                            child: AppInputText(
                              controller: controller.textEditingControllerName,
                              hintText: 'Enter Name Here',
                              showHintAsLabel: false,
                              label: 'Display Name',
                            ),
                          ),
                          ShakeView(
                            controller: controller.shakeControllerGender,
                            child: Obx(() {
                              return AppDropDownButton<String>(
                                title: 'Select Gender',
                                label: 'Gender',
                                onChanged: controller.onGenderChanged,
                                value: controller.selectedGender.value.isEmpty
                                    ? null
                                    : controller.selectedGender.value,
                                items: controller.genders.map((gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: AppText(
                                      gender.capitalizeFirst ?? '',
                                      type: AppTextType.t16sb,
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                          ShakeView(
                            controller: controller.shakeControllerDOB,
                            child: AppInputText(
                              onTap: controller.onDateOfBirthFieldTapped,
                              controller: controller.textEditingControllerDOB,
                              hintText: 'dd/mm/yyyy',
                              showHintAsLabel: false,
                              label: 'Date of Birth',
                              suffixIcon: SizedBox(
                                height: 24,
                                width: 24,
                                child: Center(
                                  child: AppSvgAsset(
                                    AppAssetsMapper.icCalendar,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          AppButton(
                            text: 'Save',
                            onPressed: controller.onSavePressed,
                            height: AppSizes.appButtonHeightLarge,
                            busy: controller.busy.value,
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
      ),
    );
  }
}
