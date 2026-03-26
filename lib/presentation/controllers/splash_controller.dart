import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  SplashController({required this.authRepository});

  final AuthRepository authRepository;

  final _authController = Get.find<AuthController>();

  @override
  void onInit() {
    _gotoLandingWithDelay();
    super.onInit();
  }

  void _gotoLandingWithDelay() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      _gotoLanding();
    });
  }

  void _gotoLanding() {
    _authController.gotoLandingPage();
  }
}
