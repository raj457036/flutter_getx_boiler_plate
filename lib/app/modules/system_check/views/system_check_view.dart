import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/system_check_controller.dart';

class SystemCheckView extends GetView<SystemCheckController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SystemCheckView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SystemCheckView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
