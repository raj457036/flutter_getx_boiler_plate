import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/global_controller.dart';
import '../../core/core.dart';

typedef Future<V> AsyncTask<V>();

Future<V> showLoader<V>({AsyncTask<V> asyncTask, Duration timeout}) async {
  final GlobalController _globalController = Get.find<GlobalController>();

  var child;
  final loader = Center(
    child: CircularProgressIndicator(),
  );

  if (Platform.isIOS || Platform.isMacOS) {
    child = CupertinoPopupSurface(
      child: loader,
    );
  } else {
    child = Dialog(child: loader);
  }

  Get.dialog(
    child,
    barrierDismissible: false,
    barrierColor: _globalController.loaderOpened ? Colors.transparent : null,
    name: Env.values.loaderRouteName,
  );

  if (asyncTask != null) {
    _globalController.startLoading();
    V result;
    if (timeout != null) {
      result = await Future.any([
        Future.delayed(timeout),
        asyncTask(),
      ]);
    } else
      result = await asyncTask();
    Get.back();
    return result;
  }

  if (timeout != null) {
    _globalController.startLoading();
    await Future.delayed(timeout);
    Get.back();
    return null;
  }
  return null;
}

hideLoader() {}
