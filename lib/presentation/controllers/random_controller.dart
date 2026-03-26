import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../data/models/user.dart';

class RandomController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<User> vibess = User.users;

  final images = <ImageData>[].obs;

  late AnimationController _animationController;
  final random = Random();

  @override
  void onInit() {
    final size = Get.size;
    for (int i = 0; i < vibess.length; i++) {
      images.add(
        ImageData(
          x: random.nextDouble() * size.width,
          y:
              random.nextDouble() *
              (size.height -
                  (Get.window.viewPadding.bottom + Get.window.viewPadding.top)),
          speed: 0.5 + random.nextDouble(),
          url: vibess[i].avatar.url,
          size: 40.0 + random.nextDouble() * 80.0,
          opacity: 0.3 + random.nextDouble() * 0.7,
        ),
      );
    }
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(_updatePositions)
          ..repeat();

    Future.delayed(Duration(seconds: 4)).then((value) {
      Get.back();
    });
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  void _updatePositions() {
    final screenWidth = Get.size.width;
    for (var img in images) {
      img.x -= img.speed;
      if (img.x < -120) {
        img.x = screenWidth;
        img.y =
            random.nextDouble() *
            (Get.size.height -
                (Get.window.viewPadding.bottom +
                    Get.window.viewPadding.top +
                    200));
      }
      double wave = sin((_animationController.value * pi));
      img.opacity = (0.7 + (wave * 0.3)).clamp(0, 1);
    }
    images.refresh();
  }
}

class ImageData {
  double x, y, speed, size, opacity;
  final String url;

  ImageData({
    required this.x,
    required this.y,
    required this.opacity,
    required this.size,
    required this.speed,
    required this.url,
  });
}
