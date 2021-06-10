import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../core/core.dart';

enum SnackbarType { success, info, error }

showSnackbar({
  required String title,
  String? message,
  SnackbarType type = SnackbarType.info,
}) {
  Color? bg;
  IconData? icon;

  switch (type) {
    case SnackbarType.success:
      bg = Env.colors.primaryColor;
      icon = Icons.check_circle_outline;
      break;
    case SnackbarType.info:
      bg = Env.colors.secondaryColor;
      icon = Icons.info_outline;
      break;
    default:
      bg = Env.colors.accentColor;
      icon = Icons.cancel_outlined;
  }

  Get.rawSnackbar(
    title: title,
    message: message ?? LocaleKeys.misc_swipe_to_close.tr,
    icon: Icon(
      icon,
      color: Colors.white,
      size: 30,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    ),
    backgroundColor: bg,
    margin: EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 20.0,
    ),
    borderRadius: 20.0,
    borderColor: Colors.white,
    borderWidth: 2,
    boxShadows: [
      BoxShadow(
        color: Colors.white24,
        offset: Offset(-8, -4),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Colors.black38,
        offset: Offset(8, 4),
        blurRadius: 10,
      )
    ],
  );
}

closeSnackbar() {
  if (Get.isSnackbarOpen ?? false) Get.back();
}
