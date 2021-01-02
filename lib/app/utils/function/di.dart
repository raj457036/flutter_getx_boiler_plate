import 'package:boiler_plate/app/global/storage/storage.dart';
import 'package:get/get.dart';

import '../../controllers/global_controller.dart';

class DI {
  DI._();

  static DI _instance = DI._();
  static DI get instance => _instance;

  void init() async {
    Get.put<GlobalController>(GlobalController());
    await DbStorageService.init();
  }
}
