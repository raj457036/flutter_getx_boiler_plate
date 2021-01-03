import 'package:get/get.dart';

import 'connectivity/connectivity_module.dart';
import 'storage/storage.dart';

// ---- MODULES EXPORT ----
export 'connectivity/connectivity_module.dart';
export 'storage/storage.dart';

// ---- MODULES IMPORT ----

loadGlobalModules() async {
  // DO NOT EDIT THIS METHOD
  // GLOBAL MODULE
  Get.lazyPut(() => ConnectivityModule.instance);
  Get.lazyPut(() => InternetConnectionChecker.instance);
  Get.lazyPut(() => CacheServiceModule.instance);
}
