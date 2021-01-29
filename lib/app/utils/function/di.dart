import 'package:get/get.dart';

import '../../controllers/global_controller.dart';
import '../../global/global.dart';

class DI {
  DI._();

  static DI _instance = DI._();
  static DI get instance => _instance;

  void init() async {
    await Modular.loadModules();
    Get.put<GlobalController>(GlobalController());
  }
}
