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

    2.delay(checkSystemHealth);
  }

  @override
  void onClose() {
    super.onClose();
  }

  checkSystemHealth() {
    final isLoggedIn = _authService.isAuthenticated;

    if (isLoggedIn) Get.offAllNamed(Routes.SYSTEM_CHECK);
  }
}
