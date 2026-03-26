import 'package:get/get.dart';

import '../../data/repositories/user_repository.dart';
import '../controllers/language_selection_controller.dart';

class LanguageSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageSelectionController>(
      () => LanguageSelectionController(
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}
