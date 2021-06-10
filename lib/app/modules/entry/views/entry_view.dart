import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/entry_controller.dart';

class EntryView extends GetView<EntryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EntryView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EntryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
