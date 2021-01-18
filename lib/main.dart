import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/core.dart';
import 'app/core/translations/translations.dart';
import 'app/global/global.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_route_observer.dart';
import 'app/utils/function/di.dart';
import 'generated/locales.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DI.instance.init();
  GlobalTranslation.I.setup(AppTranslation.translations);
  await CacheServiceModule.init(cachebleModels: []);

  LogService.I.enableColor = true;
  // LogService.I.enableSeperator = true;
  // LogService.I.enableSeperatorSpace = true;

  LogService.normal("Normal");
  LogService.debug("Debug");
  LogService.config("Config");
  LogService.info("Info");
  LogService.error("Severe");
  LogService.shout("Shout");
  LogService.warning("Warning");

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: [AppRouteObserver.instance],
      locale: Locale('en', "US"),
      translations: GlobalTranslation.I,
    ),
  );
}
