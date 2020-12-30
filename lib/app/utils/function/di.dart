import 'package:get/get.dart';

import '../../controllers/global_controller.dart';

class DI extends Bindings {
  DI._();

  static DI _instance = DI._();
  static DI instance = _instance;

  @override
  void dependencies() {
    Get.put<GlobalController>(GlobalController());
  }
}
