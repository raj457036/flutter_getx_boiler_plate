import 'dart:math';

import 'package:boiler_plate/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/environment/env.dart';
import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide.none,
    );
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: min(550, Get.width),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(size: 150),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    key: ValueKey("email-field"),
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 25.0),
                      hintText: "Email",
                      filled: true,
                      border: outlineInputBorder,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Obx(
                    () {
                      final visible = controller.passwordVisible.value;
                      return TextFormField(
                        key: ValueKey("password-field"),
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 25.0),
                          hintText: "Password",
                          filled: true,
                          border: outlineInputBorder,
                          suffixIcon: IconButton(
                            onPressed: controller.passwordVisible.toggle,
                            icon: visible
                                ? Icon(Icons.visibility)
                                : Icon(
                                    Icons.visibility_off,
                                  ),
                          ).marginOnly(right: 10.0),
                        ),
                        obscureText: !visible,
                        onFieldSubmitted: (_) => controller.onSignIn(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 20.0,
                      ),
                    ),
                  ),
                  child: Text(LocaleKeys.signin_sign_in.tr),
                  onPressed: controller.onSignIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
