import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/failures/failures.dart';
import '../../../utils/function/auth_guards.dart';

class SigninController extends AuthGuardController {
  final String successRoute;
  final Object? arguments;

  SigninController(this.successRoute, [this.arguments]) : super(false);

  bool get isAppleSignInAvailable => Platform.isIOS || Platform.isMacOS;

  onFailure(Failure? failure) {
    print(failure?.message);
  }

  onSuccess(UserCredential? user) {
    Get.offAllNamed(successRoute, arguments: arguments);
  }
}
