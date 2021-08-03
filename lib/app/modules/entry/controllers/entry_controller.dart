import 'package:get/get.dart';

import '../../../global/firebase/auth/firebase_auth_service.dart';
import '../../../routes/app_pages.dart';

class EntryController extends GetxController {
  final FirebaseAuthService _authService = Get.find<FirebaseAuthService>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    checkSystemHealth();
  }

  @override
  void onClose() {
    super.onClose();
  }

  checkSystemHealth() async {
    await 3.delay();

    final isLoggedIn = _authService.isAuthenticated;

    if (isLoggedIn) {
      Get.offNamed(Routes.HOME);
    } else {
      Get.offNamed(
        Routes.SIGNIN,
        parameters: {"successRoute": Routes.ENTRY},
      );
    }
  }
}
