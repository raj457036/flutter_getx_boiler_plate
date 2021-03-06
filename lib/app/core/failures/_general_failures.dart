part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_GENERAL_FAILURE_CODE = 300000;
const int ENVIRONMENT_FAILURE_CODE = 300001;

// --------------------- classes ---------------------

class BaseGeneralFailure extends Failure {
  BaseGeneralFailure({
    String message,
    Exception actualException,
  }) : super(
          code: BASE_GENERAL_FAILURE_CODE,
          message: message ?? LocaleKeys.failures_base_general,
          actualException: actualException,
        );
}

class EnvironmentFailure extends Failure {
  EnvironmentFailure(String message)
      : super(code: ENVIRONMENT_FAILURE_CODE, message: message);
}
