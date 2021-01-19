import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../../utils/overlays/loaders/loaders.dart';

class FirebaseController extends GetxController {
  final String appName;
  final FirebaseOptions options;

  final Rx<FirebaseApp> app = Rx<FirebaseApp>();

  FirebaseController({
    this.appName,
    this.options,
  });

  @override
  void onInit() async {
    super.onInit();
    await initFirebase();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  initFirebase({String appName, FirebaseOptions options}) async {
    final task = await showLoader(
      asyncTask: () async => await Firebase.initializeApp(
        name: appName,
        options: options,
      ),
    );

    app.value = task.result;
  }
}
