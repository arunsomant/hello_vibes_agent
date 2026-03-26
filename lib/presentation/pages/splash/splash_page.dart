import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_controller.dart';
import '../../widgets/app_logo.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final SplashController splashController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: AppLogo()),
    );
  }
}
