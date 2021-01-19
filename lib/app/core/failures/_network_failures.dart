part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_NETWORK_FAILURE_CODE = 400000;
const int NO_INTERNET_CONNECTION_FAILURE_CODE = 400001;
const int CONNECTION_REQUEST_TIMEOUT_FAILURE_CODE = 400002;

// --------------------- classes ---------------------

class BaseNetworkFailure extends Failure {
  BaseNetworkFailure({
    String message,
    Exception actualException,
  }) : super(
          code: BASE_NETWORK_FAILURE_CODE,
          message: message ?? LocaleKeys.failures_base_network,
          actualException: actualException,
        );
}

class NoInternetConnectionFailure extends Failure {
  NoInternetConnectionFailure([actualException])
      : super(
          code: NO_INTERNET_CONNECTION_FAILURE_CODE,
          message: LocaleKeys.failures_no_internet,
          actualException: actualException,
        );
}

class RequestTimeoutFailure extends Failure {
  RequestTimeoutFailure([actualException])
      : super(
          code: CONNECTION_REQUEST_TIMEOUT_FAILURE_CODE,
          message: LocaleKeys.failures_timeout,
          actualException: actualException,
        );
}
