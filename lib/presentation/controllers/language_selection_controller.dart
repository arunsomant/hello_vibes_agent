import 'package:get/get.dart';

import '../../data/models/language.dart';
import '../../data/repositories/user_repository.dart';
import '../widgets/index.dart';
import 'auth_controller.dart';

class LanguageSelectionController extends GetxController {
  final UserRepository userRepository;

  LanguageSelectionController({required this.userRepository});

  final languages = <Language>[].obs;
  final selectedLanguages = <Language>[].obs;

  final languagesBusy = false.obs;

  final busy = false.obs;

  bool isLanguageSelected(Language language) =>
      selectedLanguages.contains(language);

  @override
  void onInit() {
    _getLanguages();
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      if (authController.user.value.languages.isNotEmpty) {
        selectedLanguages(authController.user.value.languages);
      }
    }
    super.onInit();
  }

  void onLanguagesSelected(int index) {
    if (isLanguageSelected(languages[index])) {
      selectedLanguages.remove(languages[index]);
    } else {
      selectedLanguages.add(languages[index]);
    }
  }

  void onSubmitPressed() async {
    try {
      busy(true);
      final response = await userRepository.updateLanguages(selectedLanguages.value);
      if (response.success) {
        _gotoLanding();
      }
    } catch (_) {
      _showToast('Failed to update languages');
    } finally {
      busy(false);
    }
  }

  void onRefresh() {
    _getLanguages();
  }

  void _getLanguages() async {
    try {
      languagesBusy(true);
      final response = await userRepository.getLanguages();
      languages(response.languages);
    } catch (_) {
      _showToast('Failed to load languages');
    } finally {
      languagesBusy(false);
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }

  void _gotoLanding() {
    if(Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().gotoLandingPage();
    }
  }
}
