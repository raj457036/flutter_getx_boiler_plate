import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import '../../../services/global_service.dart';
import '../../misc/types.dart';
import 'loader_result.dart';

Widget getProgressIndicator({double stokeWidth = 4}) =>
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Env.colors.accentColor),
      strokeWidth: stokeWidth,
    );

_showCircularLoader(GlobalService _globalController, [Widget? bottom]) {
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

  child = Center(
    child: SizedBox.fromSize(
      size: Size.square(200),
      child: AlertDialog(
        content: loader,
      ),
    ),
  );
  if (!_globalController.loaderOpened)
    Get.dialog(
      child,
      barrierDismissible: false,
      name: Env.values.loaderRouteName,
    );
}

_showLinearLoader(GlobalService _globalController, [Widget? bottom]) {
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

/// show an overlayed loading widget till the `asyncTask` or the `future` is completed.
///
/// `asyncTask` and `future` are optional but one of them can have a non-null
/// value.
Future<LoaderResult<V?>> showLoader<V>({
  AsyncTask<V>? asyncTask,
  Future<V>? future,
  Duration? timeout,
  Widget? bottom,
  bool? linear,
  String? tag,
}) async {
  assert(
    (future == null && asyncTask != null) ||
        (future != null && asyncTask == null) ||
        (future == null && asyncTask == null),
    "asyncTask or future can be processed not both.",
  );

  final GlobalService _globalController = Get.find<GlobalService>();

  final DateTime start = DateTime.now();

  if (linear ?? Env.values.defaultLoaderTypeLinear)
    _showLinearLoader(_globalController, bottom);
  else
    _showCircularLoader(_globalController, bottom);

  Future<V>? _future;

  if (asyncTask != null)
    _future = asyncTask();
  else if (future != null) _future = future;

  if (_future != null) {
    _globalController.startLoading();
    V? result;
    bool _timeouted = false;
    Failure? failure;
    if (timeout != null) {
      try {
        result = await _future.timeout(timeout);
      } on TimeoutException {
        _timeouted = true;
      } catch (e) {
        LogService.error(e.toString());
        failure = BaseGeneralFailure(message: e.toString(), actualException: e);
      }
    } else
      result = await _future;
    Get.until((route) => !(Get.isDialogOpen ?? false));
    if (linear ?? false)
      Get.until((route) => !(Get.isBottomSheetOpen ?? false));
    final end = DateTime.now();
    _globalController.stopLoading();
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
    _globalController.stopLoading();
    return LoaderResult(true, tag, null, end.difference(start));
  }
  final end = DateTime.now();
  _globalController.stopLoading();
  return LoaderResult(true, tag, null, end.difference(start));
}
