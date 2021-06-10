import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../overlays/loaders/loaders.dart';
import 'di.dart';

Future<void> resetEverything() async {
  Get.reset();
  await DI.instance.init();
  await showLoader(timeout: 3.seconds);
  Get.offAllNamed(AppPages.INITIAL);
}
