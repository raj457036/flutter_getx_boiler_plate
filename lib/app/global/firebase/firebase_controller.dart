import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  final String appName;
  final FirebaseOptions options;

  FirebaseController({
    this.appName,
    this.options,
  });

  @override
  void onInit() {
    super.onInit();
    initFirebase();
  }

  @override
  void onReady() {}
  @override
  void onClose() {}

  initFirebase({String appName, FirebaseOptions options}) async {
    await Firebase.initializeApp(name: appName, options: options);
  }
}
