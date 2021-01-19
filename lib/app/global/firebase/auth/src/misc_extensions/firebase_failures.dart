import '../../../../../core/core.dart';

// codes
const int FIREBASE_FAILURE_CODE = 999100;
const int FIREBASE_OPERATION_NOT_ALLOWED_FAILURE_CODE = 999101;
const int FIREBASE_INVALID_EMAIL_FAILURE_CODE = 999102;
const int FIREBASE_USER_DISABLED_FAILURE_CODE = 999103;
const int FIREBASE_USER_NOT_FOUND_FAILURE_CODE = 999104;
const int FIREBASE_USER_WRONG_PASSWORD_FAILURE_CODE = 999105;
const int FIREBASE_EMAIL_ALREADY_EXIST_FAILURE_CODE = 999106;
const int FIREBASE_WEEK_PASSWORD_FAILURE_CODE = 999107;

class FirebaseFailure extends Failure {
  FirebaseFailure(Object exception, String message)
      : super(
          code: FIREBASE_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}

class FirebaseOperationNotAllowedFailure extends Failure {
  FirebaseOperationNotAllowedFailure(Object exception, String message)
      : super(
          code: FIREBASE_OPERATION_NOT_ALLOWED_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}

class FirebaseInvalidEmailFailure extends Failure {
  FirebaseInvalidEmailFailure(Object exception, String message)
      : super(
          code: FIREBASE_INVALID_EMAIL_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}

class FirebaseUserDisabledFailure extends Failure {
  FirebaseUserDisabledFailure(Object exception, String message)
      : super(
          code: FIREBASE_INVALID_EMAIL_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}

class FirebaseUserNotFoundFailure extends Failure {
  FirebaseUserNotFoundFailure(Object exception, String message)
      : super(
          code: FIREBASE_INVALID_EMAIL_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}

class FirebaseUserWrongPasswordFailure extends Failure {
  FirebaseUserWrongPasswordFailure(Object exception, String message)
      : super(
          code: FIREBASE_INVALID_EMAIL_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}

class FirebaseEmailAlreadyInUserFailure extends Failure {
  FirebaseEmailAlreadyInUserFailure(Object exception, String message)
      : super(
          code: FIREBASE_EMAIL_ALREADY_EXIST_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}

class FirebaseWeekPasswordFailure extends Failure {
  FirebaseWeekPasswordFailure(Object exception, String message)
      : super(
          code: FIREBASE_WEEK_PASSWORD_FAILURE_CODE,
          actualException: exception,
          message: message,
        );
}
