part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_NETWORK_FAILURE_CODE = 400000;

// --------------------- classes ---------------------

class BaseNetworkFailure extends Failure {
  const BaseNetworkFailure({
    String message,
    Exception actualException,
  }) : super(
          code: BASE_NETWORK_FAILURE_CODE,
          message: message ?? "network error encountered.",
          actualException: actualException,
        );
}
