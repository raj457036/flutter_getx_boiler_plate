part of 'exceptions.dart';

class NetworkException extends BaseException {
  const NetworkException({
    String message,
    actualError,
  }) : super(
          message: message ?? "Network exception encounterd",
          actualError: actualError,
        );
}

class NoInternetConnectionException extends NetworkException {
  NoInternetConnectionException([actualError])
      : super(
          message: "Internet not available",
          actualError: actualError,
        );
}
