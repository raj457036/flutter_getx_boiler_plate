import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../core/core.dart';
import '../services/global_service.dart';

class AppRouteObserver extends GetObserver {
  GlobalService? _controller;

  AppRouteObserver._();

  static AppRouteObserver _instance = AppRouteObserver._();
  static AppRouteObserver get instance => _instance;

  GlobalService get controller {
    if (_controller != null) return _controller!;
    _controller = Get.find<GlobalService>();
    return _controller!;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute?.settings.name == Env.values.loaderRouteName) {
      controller.stopLoading();
    }

    controller.onRoutePop();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == Env.values.loaderRouteName) {
      controller.startLoading();
    }
    controller.onRoutePush(route);
  }
}
