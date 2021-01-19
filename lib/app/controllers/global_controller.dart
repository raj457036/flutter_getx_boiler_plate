import 'package:get/get.dart';

import '../core/core.dart';

class GlobalController extends GetxController {
  final _loaderOpened = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  // ------- getters -------
  bool get loaderOpened => _loaderOpened.value;

  // ------- public methods -------
  startLoading() {
    _loaderOpened.value = true;
  }

  stopLoading() {
    _loaderOpened.value = false;
  }

  handleFailure(Failure failure) {
    LogService.error(failure.message);
  }
}
