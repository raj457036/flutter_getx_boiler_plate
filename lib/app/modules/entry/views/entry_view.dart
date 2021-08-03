import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/overlays/loaders/loaders.dart';
import '../controllers/entry_controller.dart';

class EntryView extends GetView<EntryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 150),
            getProgressIndicator(stokeWidth: 3).paddingOnly(top: 20.0)
          ],
        ),
      ),
    );
  }
}
