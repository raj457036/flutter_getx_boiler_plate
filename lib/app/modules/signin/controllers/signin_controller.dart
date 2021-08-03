import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/failures/failures.dart';
import '../../../global/firebase/auth/firebase_auth_module.dart';
import '../../../global/firebase/auth/firebase_auth_service.dart';
import '../../../utils/function/auth_guards.dart';
import '../../../utils/overlays/loaders/loaders.dart';
import '../../../utils/overlays/snackbar/snackbar.dart';

class SigninController extends AuthGuardController {
  final String successRoute;
  final Object? arguments;
  final TextEditingController emailController =
      TextEditingController(text: "test@test.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");

  final passwordVisible = false.obs;

  final authRepo = Get.find<FireabaseEmailAuthRepository>();
  final authService = Get.find<FirebaseAuthService>();

  SigninController(this.successRoute, [this.arguments]) : super(false);

  // bool get isAppleSignInAvailable => Platform.isIOS || Platform.isMacOS;

  @override
  onInit() {
    super.onInit();
    ever(authService.firebaseUserListener, (_) => onSuccess(null));
  }

  onFailure(Failure? failure) {
    showSnackbar(title: failure?.message ?? "Sign In Failed");
  }

  onSuccess(UserCredential? user) {
    Get.offAllNamed(successRoute, arguments: arguments);
  }

  onSignIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!GetUtils.isEmail(email)) {
      showSnackbar(title: "Invalid Email!");
      return;
    }

    final task = await showLoader(
      future: authRepo.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
    task.result?.fold(onFailure, onSuccess);
  }
}
