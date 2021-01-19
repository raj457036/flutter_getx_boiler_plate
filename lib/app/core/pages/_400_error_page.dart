import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.route_400_error.tr),
      ),
      body: Center(
        child: Text(LocaleKeys.route_400_error.tr),
      ),
    );
  }
}
