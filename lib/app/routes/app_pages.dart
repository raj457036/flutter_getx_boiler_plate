import 'package:get/get.dart';

import '../core/core.dart';
import '../modules/entry/bindings/entry_binding.dart';
import '../modules/entry/views/entry_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/system_check/bindings/system_check_binding.dart';
import '../modules/system_check/views/system_check_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ENTRY;

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
    GetPage(
      name: _Paths.NO_INTERNET,
      page: () => NoInternetConnectionPage(),
      fullscreenDialog: true,
      popGesture: false,
    ),

    // app pages
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SYSTEM_CHECK,
      page: () => SystemCheckView(),
      binding: SystemCheckBinding(),
    ),
    GetPage(
      name: _Paths.ENTRY,
      page: () => EntryView(),
      binding: EntryBinding(),
    ),
  ];
}
