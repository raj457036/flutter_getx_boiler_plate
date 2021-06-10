import '../overlays/snackbar/snackbar.dart';
import '../../../generated/locales.g.dart';
import 'package:get/get.dart';

import '../../global/firebase/auth/firebase_auth_service.dart';
import '../../routes/app_pages.dart';
import '../misc/route_argument.dart';

class AuthGuardController extends GetxController {
  final _authService = Get.find<FirebaseAuthService>();

  final bool needAuthentication;

  AuthGuardController(this.needAuthentication);

  @override
  void onReady() {
    if (needAuthentication && !_authService.isAuthenticated) {
      Get.offAllNamed(
        Routes.SIGNIN,
        arguments: RouteArguments({
          "successRoute": Get.currentRoute,
          "arguments": Get.arguments,
        }),
      );

      showSnackbar(
        title: LocaleKeys.signin_permission_denied.tr,
        message: LocaleKeys.signin_permission_note.tr,
        type: SnackbarType.error,
      );
    }

    if (!needAuthentication && _authService.isAuthenticated) {
      Get.back();
      showSnackbar(
        title: LocaleKeys.signin_permission_denied.tr,
        message: LocaleKeys.failures_no_access_route.tr,
        type: SnackbarType.error,
      );
    }

    super.onReady();
  }
}
