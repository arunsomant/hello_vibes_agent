import 'dart:ui';

import 'package:get/get.dart';

import '../../presentation/routes/app_route_observer.dart';

extension GetNavigationExtensions on GetInterface {
  void offUntilOrToNamed(String routeName) {
    if (AppRouteObserver.routeStack.contains(routeName)) {
      Get.until((route) => route.settings.name == routeName);
    } else {
      Get.toNamed(routeName, arguments: arguments);
    }
  }
}

abstract class JsonEnum<T> {
  T get value;

  T get defaultValue;
}

extension GenericEnumParser<T extends JsonEnum> on Iterable<T> {
  T fromJson(String? json) {
    final T fallback = first.defaultValue;
    if (json == null) return fallback;
    return firstWhere((e) => e.value == json, orElse: () => fallback);
  }
}extension ColorExtension on Color {
  String toHex({bool leadingHashSign = true}) {
   final hexString = toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
return '${leadingHashSign ? '#' : ''}$hexString';
  }
}
