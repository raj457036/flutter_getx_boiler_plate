import 'package:get/get.dart';

import '../controllers/system_check_controller.dart';

class SystemCheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SystemCheckController>(
      () => SystemCheckController(),
    );
  }
}
