import 'package:get/get.dart';

import '../../../utils/misc/route_argument.dart';
import '../controllers/signin_controller.dart';

class SigninBinding extends Bindings {
  @override
  void dependencies() {
    final successRoute = RouteArguments.current.get("successRoute");
    final arguments = RouteArguments.current.get("arguments");
    Get.lazyPut<SigninController>(
      () => SigninController(successRoute, arguments),
    );
  }
}
