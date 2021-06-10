import 'package:get/get.dart';

import '../controllers/entry_controller.dart';

class EntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryController>(
      () => EntryController(),
    );
  }
}
