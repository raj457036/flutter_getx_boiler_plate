import 'package:get/get.dart';

import '../core/core.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    // core pages
    GetPage(
      name: _Paths.NOT_FOUND,
      page: () => NotFoundPage(),
    ),
    GetPage(
      name: _Paths.ERROR_ENCOUNTERED,
      page: () => ErrorPage(),
      fullscreenDialog: true,
    ),

    // app pages
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
