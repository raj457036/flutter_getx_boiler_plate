import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';
import '../../utils/overlays/loaders/loaders.dart';

class NoInternetConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.failures_no_internet.tr,
              // style: Env.textStyle.display,
            ),
            SizedBox(height: 20.0),
            getProgressIndicator(),
            SizedBox(height: 20.0),
            Text(
              LocaleKeys.misc_reconnecting.tr,
            ),
          ],
        ),
      ),
    );
  }
}
