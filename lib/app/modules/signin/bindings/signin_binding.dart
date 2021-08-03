import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

import '../../../utils/misc/route_argument.dart';
import '../controllers/signin_controller.dart';

class SigninBinding extends Bindings {
  @override
  void dependencies() {
    final successRoute = RouteParameters.current.get(
      "successRoute",
      defaultValue: Routes.HOME,
    );
    final arguments = RouteParameters.current.get("arguments");

    Get.lazyPut<SigninController>(
      () => SigninController(successRoute, arguments),
    );
  }
}
