import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/global_controller.dart';
import '../core/core.dart';

class AppRouteObserver extends GetObserver {
  final GlobalController _controller = Get.find<GlobalController>();

  AppRouteObserver._();

  static AppRouteObserver _instance = AppRouteObserver._();
  static AppRouteObserver get instance => _instance;

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute.settings.name == Env.values.loaderRouteName) {
      _controller.stopLoading();
    }
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == Env.values.loaderRouteName) {
      _controller.startLoading();
    }
  }
}
