import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../firebase_controller.dart';

class FirebaseAuthController extends GetxController {
  final FirebaseController firebaseController = Get.find<FirebaseController>();

  // private props
  StreamSubscription _authSubscription;
  final RxBool isAuthenticatedListener = false.obs;
  final Rx<User> firebaseUserListener = Rx<User>();

  // getters
  FirebaseAuth get auth => FirebaseAuth.instance;
  bool get isAuthenticated => isAuthenticatedListener.value;
  User get firebaseUser => firebaseUserListener.value;
  bool get isUserAnonymous => firebaseUser?.isAnonymous ?? true;

  @override
  void onInit() {
    super.onInit();
    auth.setLanguageCode(Get.locale.toString());
    // subscribing to auth state change
    _authSubscription = auth.authStateChanges().listen(_onAuthStateChange);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _authSubscription.cancel();
  }

  // privates

  _onAuthStateChange(User user) {
    if (user == null) {
      isAuthenticatedListener.value = false;
      firebaseUserListener.value = null;
    } else {
      isAuthenticatedListener.value = true;
      firebaseUserListener.value = user;
    }
  }
}
