import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRouteObserver extends GetObserver {
  static List<String?> routeStack = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    routeStack.add(route.settings.name);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    routeStack.remove(route.settings.name);
  }
}
