import 'package:boiler_plate/app/utils/overlays/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    print('Showing loader');
    showLoader(
      asyncTask: () async => await showLoader(
        asyncTask: () async => await showLoader(
          asyncTask: () async => await showLoader(
            timeout: Duration(seconds: 2),
            tag: "fourth",
          ),
          timeout: Duration(seconds: 4),
          bottom: Text("Loading..."),
          linear: false,
          tag: "third",
        ),
        timeout: Duration(seconds: 10),
        tag: "second",
      ),
      timeout: Duration(seconds: 5),
      bottom: Text("Loading..."),
      linear: false,
      tag: "first",
    ).then((value) => print(value));
  }

  @override
  void onClose() {}

  void increment() => count.value++;
}
