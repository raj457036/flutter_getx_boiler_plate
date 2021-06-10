import 'package:get/get.dart';

class SystemCheckController extends GetxController {
  final currentStatus = "".obs;

  /// This indicator can be used to identify the point in time at which the check
  /// failed like a fail code.
  final haltState = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    startSystemCheck();
  }

  @override
  void onClose() {
    super.onClose();
  }

  startSystemCheck() {
    // check 1
    // check 2
    // check 3

    // Navigate to certain route based on the check results
  }
}
