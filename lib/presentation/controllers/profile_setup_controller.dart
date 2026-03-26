import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/utils/app_formatter.dart';
import '../../core/utils/app_validator.dart';
import '../../data/models/avatar.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import '../routes/app_routes.dart';
import '../widgets/app_dialog.dart';
import '../widgets/shake_view.dart';
import 'auth_controller.dart';

class ProfileSetupController extends GetxController
    with GetTickerProviderStateMixin {
  final UserRepository userRepository;

  ProfileSetupController({required this.userRepository});

  User get user => Get.find<AuthController>().user.value;

  List<String> genders = ['male', 'female'];

  final avatarList = <Avatar>[].obs;

  final selectedAvatar = Avatar().obs;

  final busy = false.obs;

  final avatarsBusy = false.obs;

  final termsAccepted = false.obs;

  final textEditingControllerName = TextEditingController();

  late final shakeControllerName = ShakeController(vsync: this);

  final textEditingControllerDOB = TextEditingController();

  late final shakeControllerDOB = ShakeController(vsync: this);

  final selectedGender = ''.obs;

  late final shakeControllerGender = ShakeController(vsync: this);

  late final shakeControllerTerms = ShakeController(vsync: this);

  bool fromProfileEdit = false;

  @override
  void onClose() {
    textEditingControllerName.dispose();
    textEditingControllerDOB.dispose();
    shakeControllerName.dispose();
    shakeControllerGender.dispose();
    shakeControllerTerms.dispose();
    shakeControllerDOB.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    getAvatarList();
    _getUserProfile();
    super.onInit();
  }

  void onTermsCheckedPressed() {
    termsAccepted.toggle();
  }

  void onAvatarChanged(Avatar avatar) {
    selectedAvatar(avatar);
  }

  void onGenderChanged(String value) {
    selectedGender(value);
  }

  void onSubmitPressed() {
    if (!_validateInputs()) {
      return;
    }
    if (termsAccepted.isFalse && !fromProfileEdit) {
      _showToast('Please accept the terms and conditions');
      shakeControllerTerms.shake();
      return;
    }
    _updateProfile();
  }

  void _updateProfile() async {
    try {
      busy(true);
      final response = await userRepository.updateUserProfile(
        name: textEditingControllerName.text.trim(),
        gender: selectedGender.value,
        dateOfBirth: AppFormatter.parseDDMMYYYY(
          textEditingControllerDOB.text.trim(),
        )!,
        avatarId: selectedAvatar.value.id,
      );
      if (response.success) {
        if (fromProfileEdit) {
          Get.find<AuthController>().getUserProfile();
          Get.back();
        } else {
          _gotoLanguageSelectionPage();
        }
      } else {
        _showToast(response.message);
      }
    } catch (_) {
    } finally {
      busy(false);
    }
  }

  void _getUserProfile() {
    textEditingControllerName.text = user.name;
    textEditingControllerDOB.text = AppFormatter.formatDDMMYYYY(user.dob);
    selectedGender(user.gender);
    selectedAvatar(user.avatar);
  }

  void _gotoLanguageSelectionPage() {
    Get.offNamed(AppRoutes.languageSelection);
  }

  void onDateOfBirthFieldTapped() {
    final initialDate = DateTime.now().subtract(Duration(days: 365 * 18));
    AppDialog.showAppDatePicker(
      initialDate: initialDate,
      firstDate: DateTime(1950, 01, 01),
      lastDate: initialDate,
      onDateSelected: (selectedDate) {
        textEditingControllerDOB.text = AppFormatter.formatDDMMYYYY(
          selectedDate,
        );
      },
    );
  }

  void getAvatarList() async {
    try {
      avatarsBusy(true);
      final response = await userRepository.getAvatarList();
      if (response.success) {
        avatarList(response.avatars);
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Failed to load avatars');
    } finally {
      avatarsBusy(false);
    }
  }

  void onSavePressed() {
    fromProfileEdit = true;
    if (!_validateInputs()) {
      return;
    }
    _updateProfile();
  }

  bool _validateInputs() {
    if (textEditingControllerName.text.trim().isEmpty) {
      _showToast('Please enter your name');
      shakeControllerName.shake();
      return false;
    }
    if (selectedGender.value.isEmpty) {
      _showToast('Please select your gender');
      shakeControllerGender.shake();
      return false;
    }
    final dob = AppFormatter.parseDDMMYYYY(
      textEditingControllerDOB.text.trim(),
    );
    if (dob == null || !AppValidator.validateDateOfBirth(dob)) {
      _showToast('You must be at least 18 years old to use this app');
      shakeControllerDOB.shake();

      return false;
    }
    return true;
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
