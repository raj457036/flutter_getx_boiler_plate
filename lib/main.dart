import 'dart:io';

import 'package:boiler_plate/app/core/connection/network_availability.dart';
import 'package:boiler_plate/app/core/core.dart';
import 'package:boiler_plate/app/global/connectivity/connectivity_handler.dart';
import 'package:boiler_plate/app/utils/function/logger.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_route_observer.dart';
import 'app/utils/function/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: [AppRouteObserver.instance],
      initialBinding: DI.instance,
    ),
  );
}
