import '../../../../../core/core.dart';

//codes
const int FIREBASE_ACCOUNT_EXIST_WITH_DIFFERENT_CRED_FAILURE_CODE = 999108;
const int FIREBASE_INVALID_CRED_FAILURE_CODE = 999109;
const int FIREBASE_INVALID_VERIFICATION_CODE_FAILURE_CODE = 999110;
const int FIREBASE_INVALID_VERIFICATION_ID_FAILURE_CODE = 999111;
const int FIREBASE_PHONE_AUTH_INVALID_PHONE_NUMBER_FAILURE_CODE = 999112;

class FirebaseAccountExistsWithDifferentCredFailure extends Failure {
  FirebaseAccountExistsWithDifferentCredFailure(
      Object exception, String message)
      : super(
          code: FIREBASE_ACCOUNT_EXIST_WITH_DIFFERENT_CRED_FAILURE_CODE,
          actualException: exception,
          msg: message,
        );
}

class FirebaseInvalidCredFailure extends Failure {
  FirebaseInvalidCredFailure(Object exception, String message)
      : super(
          code: FIREBASE_INVALID_CRED_FAILURE_CODE,
          actualException: exception,
          msg: message,
        );
}

class FirebaseInvalidVerificationCodeFailure extends Failure {
  FirebaseInvalidVerificationCodeFailure(Object exception, String message)
      : super(
          code: FIREBASE_INVALID_VERIFICATION_CODE_FAILURE_CODE,
          actualException: exception,
          msg: message,
        );
}

class FirebaseInvalidVerificationIdFailure extends Failure {
  FirebaseInvalidVerificationIdFailure(Object exception, String message)
      : super(
          code: FIREBASE_INVALID_VERIFICATION_ID_FAILURE_CODE,
          actualException: exception,
          msg: message,
        );
}

class FirebasePhoneAuthInvalidPhoneNumberFailure extends Failure {
  FirebasePhoneAuthInvalidPhoneNumberFailure(Object exception, String message)
      : super(
          code: FIREBASE_PHONE_AUTH_INVALID_PHONE_NUMBER_FAILURE_CODE,
          actualException: exception,
          msg: message,
        );
}
