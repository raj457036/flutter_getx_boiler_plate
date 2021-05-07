part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_DATABASE_FAILURE_CODE = 200000;

// --------------------- classes ---------------------

class BaseDatabaseFailure extends Failure {
  BaseDatabaseFailure({
    String? message,
    Exception? actualException,
  }) : super(
          code: BASE_DATABASE_FAILURE_CODE,
          message: message ?? LocaleKeys.failures_base_database,
          actualException: actualException,
        );
}
