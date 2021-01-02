import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/core.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_route_observer.dart';
import 'app/utils/function/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Env.I.init();
  await GlobalTranslation.setup({
    "en_US": "translations/en_US.json",
  });

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: [AppRouteObserver.instance],
      initialBinding: DI.instance,
      locale: Locale("en", "US"),
      // locale: Get.deviceLocale,
    ),
  );
}
