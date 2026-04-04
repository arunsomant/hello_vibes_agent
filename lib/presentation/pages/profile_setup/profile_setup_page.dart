import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/profile_setup_controller.dart';
import '../../widgets/index.dart';

class ProfileSetupPage extends GetView<ProfileSetupController> {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: Stack(
            children: [
              AppBackground(),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: AppSpacings.s8,
                        children: [
                          const SizedBox(height: AppSpacings.s48),
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
                          Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundRaised,
                        borderRadius: BorderRadius.circular(AppRadii.r32),
                      ),
                      margin: EdgeInsetsGeometry.symmetric(
                        horizontal: AppSpacings.s24,
                      ),
                      padding: EdgeInsetsGeometry.all(AppSpacings.s20),
                      child: Column(
                        spacing: AppSpacings.s32,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            spacing: AppSpacings.s16,
                            children: [
                              ShakeView(
                                controller: controller.shakeControllerName,
                                child: AppInputText(
                                  controller:
                                      controller.textEditingControllerName,
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
                                    value:
                                        controller.selectedGender.value.isEmpty
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
                                  keyboardType: TextInputType.none,
                                  onTap: controller.onDateOfBirthFieldTapped,
                                  controller:
                                      controller.textEditingControllerDOB,
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
                              ShakeView(
                                controller: controller.shakeControllerTerms,
                                child: Obx(() {
                                  return TermsAndPrivacy(
                                    termsAccepted:
                                        controller.termsAccepted.isTrue,
                                    onTermsChecked:
                                        controller.onTermsCheckedPressed,
                                  );
                                }),
                              ),
                            ],
                          ),
                          Obx(() {
                            return AppButton(
                              busy: controller.busy.isTrue,
                              text: 'Submit',
                              onPressed: controller.onSubmitPressed,
                              height: AppSizes.appButtonHeightLarge,
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacings.s48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
