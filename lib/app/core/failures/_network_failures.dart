part of 'failures.dart';

// --------------------- codes ---------------------

const int BASE_NETWORK_FAILURE_CODE = 400000;
const int NO_INTERNET_CONNECTION_FAILURE_CODE = 400001;

// --------------------- classes ---------------------

class BaseNetworkFailure extends Failure {
  BaseNetworkFailure({
    String message,
    Exception actualException,
  }) : super(
          code: BASE_NETWORK_FAILURE_CODE,
          message: message ?? "failure_base_network".tr,
          actualException: actualException,
        );
}

class NoInternetConnectionFailure extends Failure {
  NoInternetConnectionFailure([actualException])
      : super(
          code: NO_INTERNET_CONNECTION_FAILURE_CODE,
          message: "failure_no_internet".tr,
          actualException: actualException,
        );
}
