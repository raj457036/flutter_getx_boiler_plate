// ---- MODULES EXPORT ----
// ---- MODULES IMPORT ----
import 'package:boiler_plate/app/global/firebase/dynamic_link/dynamic_link_controller.dart';
import 'package:boiler_plate/app/global/firebase/messaging/messaging.dart';
import 'package:get/get.dart';

import 'connectivity/connectivity_module.dart';
import 'firebase/auth/firebase_auth_controller.dart';
import 'firebase/auth/firebase_auth_module.dart';
import 'storage/storage.dart';

export 'connectivity/connectivity_module.dart';
export 'firebase/messaging/messaging.dart';
export 'storage/storage.dart';

class Modular {
  static loadModules() {
    // ** NETWORK **

    // Load Connectivity Module for listing to network state
    Get.lazyPut(() => ConnectivityModule(), fenix: true);

    // ** CACHE **

    // Load Cache Services for cachable models
    Get.lazyPut(() => CacheServiceModule.instance, fenix: true);

    // ** AUTH **

    // Load Firebase Email Auth Repository
    Get.lazyPut(() => FireabaseEmailAuthRepository(), fenix: true);

    // Load Firebase Phone Auth Modules
    Get.lazyPut(() => FirebasePhoneAuthController(), fenix: true);
    Get.lazyPut(() => FirebasePhoneAuthRepository.instance, fenix: true);

    // Load Firebase OAuth Facebook Repository
    Get.lazyPut(() => FirebaseFacebookAuthRepository(), fenix: true);

    // Load Firebase OAuth GitHub Repository
    // TODO 2 : Make sure to setup 'github-client-id' and 'github-client-secret' in environment
    Get.lazyPut(() => FirebaseGitHubAuthRepository()..init(), fenix: true);

    // Load Firebase OAuth Google Repository
    Get.lazyPut(() => FirebaseGoogleAuthRepo(), fenix: true);

    // Load Firebase OAuth Twitter Repository
    // TODO 3 : Make sure to setup 'twitter-consumer-key' and 'twitter-consumer-secret' in environment
    Get.lazyPut(() => FirebaseTwitterAuthRepo()..init(), fenix: true);

    // Load Firebase Auth Controller
    Get.lazyPut(() => FirebaseAuthController(), fenix: true);

    // Load Firebase External Profile Module
    //? Dependent on [FirebaseAuthController]
    Get.lazyPut(() => FirebaseUserProfileProviderImpl());
    Get.lazyPut(() => FirebaseUserProfileRepository());

    // ** MESSAGING **

    // TODO 6 : REMEMBER TO ASK FOR NOTIFICATION PERMISSION BY CALLING 'requestNotificationPermissions()'
    Get.put(MessagingService());

    // ** DYNAMIC LINK **

    Get.put(DynamicLinkController());
  }
}
