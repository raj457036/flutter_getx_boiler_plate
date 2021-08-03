import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../../core/core.dart';
import '../../../../../../services/global_service.dart';
import '../firebase_phone_auth_repo.dart';

class FirebasePhoneAuthController extends GetxController {
  final GlobalService _globalController = Get.find<GlobalService>();
  final FirebasePhoneAuthRepository _repository =
      FirebasePhoneAuthRepository.instance;

  late Timer? _timer;

  final sendingOTP = false.obs;
  final verifyingOTP = false.obs;
  final otpSent = false.obs;
  final phoneVerified = false.obs;
  final _resendTimeLeft = 30.obs;
  final _sentCounter = 0.obs;

  int get _canResendAgainIn => 30 * _sentCounter.value;
  bool get canResend => _resendTimeLeft.value <= 0;
  int get resendTimeLeft => _resendTimeLeft.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  sendOTP(String phoneNumber, {bool resend = false}) async {
    if (resend && !canResend || phoneVerified.value) return;

    sendingOTP.value = true;
    _sentCounter.value++;
    _startTimer();

    final result = await _repository.sendOTP(
      phoneNumber,
      resend: resend,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
    );

    result.fold((value) {
      sendingOTP.value = false;
      _globalController.handleFailure(value);
    }, (value) => null);
  }

  Future<UserCredential> signIn(String code) async {
    verifyingOTP.value = true;

    final result = await _repository.signInWithOTP(code);

    return result.fold(
      (value) => _globalController.handleFailure(value),
      (value) {
        verifyingOTP.value = false;
        phoneVerified.value = true;
        return value;
      },
    );
  }

  _startTimer() {
    _timer?.cancel();
    _resendTimeLeft.value = _canResendAgainIn;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _resendTimeLeft.value--;

      if (_resendTimeLeft.value <= 0) {
        _timer?.cancel();
      }
    });
  }

  _verificationCompleted(PhoneAuthCredential credential) {
    sendingOTP.value = false;
    otpSent.value = true;
  }

  _verificationFailed(Failure failure) {
    sendingOTP.value = false;
    _globalController.handleFailure(failure);
  }
}
