import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../../generated/locales.g.dart';
import '../../../../../core/core.dart';
import '../../firebase_auth_controller.dart';
import '../misc_extensions/extended_auth_failures.dart';
import '../misc_extensions/extended_auth_repo.dart';
import '../misc_extensions/firebase_failures.dart';

class FirebasePhoneAuthRepository extends FirebaseAuthExtendedRepo {
  final FirebaseAuthController _controller = Get.find<FirebaseAuthController>();

  FirebaseAuth get auth => _controller.auth;

  FirebasePhoneAuthRepository._();
  static FirebasePhoneAuthRepository _instance =
      FirebasePhoneAuthRepository._();
  static FirebasePhoneAuthRepository get instance => _instance;

  late String _verificationId;
  late int? _resendToken;

  Future<Either<Failure, void>> sendOTP(
    String phoneNumber, {
    Function(Failure)? verificationFailed,
    Function(PhoneAuthCredential)? verificationCompleted,
    bool resend = false,
  }) async {
    if (!resend) _resetState();

    try {
      await auth.verifyPhoneNumber(
        forceResendingToken: resend ? _resendToken : null,
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          if (verificationCompleted != null) verificationCompleted(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Failure failure;
          switch (e.code) {
            case "invalid-phone-number":
              failure = FirebasePhoneAuthInvalidPhoneNumberFailure(
                e,
                LocaleKeys.firebase_invalid_phone_number.tr,
              );
              break;
            default:
              failure = FirebaseFailure(e, LocaleKeys.firebase_failure);
          }

          if (verificationFailed != null) verificationFailed(failure);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
      return Right(null);
    } catch (e) {
      return handleException(e);
    }
  }

  Future<Either<Failure, UserCredential>> signInWithOTP(String code) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: code,
    );

    // Sign the user in (or link) with the credential
    try {
      final result = await auth.signInWithCredential(phoneAuthCredential);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  _resetState() {
    _verificationId = "";
    _resendToken = null;
  }
}
