import 'package:boiler_plate/app/data/models/note_model.dart';
import 'package:boiler_plate/app/data/models/user_model.dart';
import 'package:boiler_plate/app/global/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/core.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_route_observer.dart';
import 'app/utils/function/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DI.instance.init();

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
      locale: Locale("en", "US"),
      translations: GlobalTranslation.I,
      // locale: Get.deviceLocale,
    ),
  );
}
