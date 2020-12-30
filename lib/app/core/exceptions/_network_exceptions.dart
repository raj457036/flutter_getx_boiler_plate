part of 'exceptions.dart';

class NetworkException extends BaseException {
  const NetworkException({
    String message,
    Exception actualError,
  }) : super(
          message: message ?? "network exception encounterd",
          actualError: actualError,
        );
}
