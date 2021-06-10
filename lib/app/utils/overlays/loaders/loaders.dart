import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/global_controller.dart';
import '../../../core/core.dart';
import '../../misc/types.dart';
import 'loader_result.dart';

Widget getProgressIndicator() => CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(Env.colors.primaryColor),
    );

_showCircularLoader(GlobalController _globalController, [Widget? bottom]) {
  Widget child;
  final loader = AspectRatio(
    aspectRatio: 1,
    child: Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getProgressIndicator(),
        if (bottom != null)
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: bottom,
          ),
      ],
    )),
  );

  if (Platform.isIOS || Platform.isMacOS) {
    child = CupertinoAlertDialog(
      content: loader,
    );
  } else {
    child = AlertDialog(
      content: loader,
    );
  }
  if (!_globalController.loaderOpened)
    Get.dialog(
      child.paddingAll(bottom == null ? Get.width / 4 : Get.width / 6),
      barrierDismissible: false,
      name: Env.values.loaderRouteName,
    );
}

_showLinearLoader(GlobalController _globalController, [Widget? bottom]) {
  final loader = IntrinsicHeight(
    child: Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LinearProgressIndicator()
              .paddingSymmetric(horizontal: 10.0, vertical: 5.0),
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: bottom,
            ),
        ],
      )),
    ),
  );
  if (!_globalController.loaderOpened)
    Get.bottomSheet(
      loader,
      isDismissible: false,
      enableDrag: false,
      settings: RouteSettings(name: Env.values.loaderRouteName),
    );
}

Future<LoaderResult<V?>> showLoader<V>({
  AsyncTask<V>? asyncTask,
  Duration? timeout,
  Widget? bottom,
  bool? linear,
  String? tag,
}) async {
  final GlobalController _globalController = Get.find<GlobalController>();

  final DateTime start = DateTime.now();

  if (linear ?? Env.values.defaultLoaderTypeLinear)
    _showLinearLoader(_globalController, bottom);
  else
    _showCircularLoader(_globalController, bottom);

  if (asyncTask != null) {
    _globalController.startLoading();
    V? result;
    bool _timeouted = false;
    Failure? failure;
    if (timeout != null) {
      try {
        result = await asyncTask().timeout(timeout);
      } on TimeoutException {
        _timeouted = true;
      } catch (e) {
        LogService.error(e.toString());
        failure = BaseGeneralFailure(message: e.toString(), actualException: e);
      }
    } else
      result = await asyncTask();
    Get.until((route) => !(Get.isDialogOpen ?? false));
    if (linear ?? false)
      Get.until((route) => !(Get.isBottomSheetOpen ?? false));
    final end = DateTime.now();
    return LoaderResult(
      _timeouted,
      tag,
      result,
      end.difference(start),
      failure: failure,
    );
  }

  if (timeout != null) {
    _globalController.startLoading();
    await Future.delayed(timeout);
    Get.until((route) => !(Get.isDialogOpen ?? false));
    final end = DateTime.now();
    return LoaderResult(true, tag, null, end.difference(start));
  }
  final end = DateTime.now();
  return LoaderResult(true, tag, null, end.difference(start));
}
