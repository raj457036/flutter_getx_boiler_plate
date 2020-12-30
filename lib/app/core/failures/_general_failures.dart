part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_GENERAL_FAILURE_CODE = 300000;

// --------------------- classes ---------------------

class BaseGeneralFailure extends Failure {
  const BaseGeneralFailure({
    String message,
    Exception actualException,
  }) : super(
          code: BASE_GENERAL_FAILURE_CODE,
          message: message ?? "some error encountered.",
          actualException: actualException,
        );
}
