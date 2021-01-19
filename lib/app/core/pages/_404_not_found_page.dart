import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.route_404_not_found.tr),
      ),
      body: Center(
        child: Text(LocaleKeys.route_404_not_found.tr),
      ),
    );
  }
}
