import 'dart:async';
import 'dart:ui' as ui;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/core/core.dart';
import 'app/core/themes/themes.dart';
import 'app/core/translations/translations.dart';
import 'app/global/firebase/analytics/analytics.dart';
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

  runZonedGuarded(
    () {
      runApp(
        GetMaterialApp(
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          navigatorObservers: [
            AppRouteObserver.instance,
            FirebaseAnalyticsProvider.instance.observer,
          ],
          builder: scopeReleasingBuilder,
          locale: getLocaleForDebug(),
          translations: GlobalTranslation.I,
          theme: Themes.baseTheme,
          darkTheme: Themes.baseTheme,
        ),
      );
    },
    FirebaseCrashlytics.instance.recordError,
  );
}

Locale getLocaleForDebug() {
  late String code;
  switch (ui.window.locale.languageCode) {
    case 'es':
      code = "es_ES";
      break;
    case 'en':
    default:
      code = "en_US";
      break;
  }
  initializeDateFormatting(code);
  final _splited = code.split("_");
  return Locale(_splited.first, _splited.last);
}

Widget scopeReleasingBuilder(context, child) {
  return GestureDetector(
    onTap: () {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).unfocus();
      } catch (e) {}
    },
    child: child,
  );
}
