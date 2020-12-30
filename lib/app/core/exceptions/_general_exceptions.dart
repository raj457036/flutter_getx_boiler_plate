part of 'exceptions.dart';

class GeneralException extends BaseException {
  const GeneralException({
    String message,
    Exception actualError,
  }) : super(
          message: message ?? "some exception encounterd",
          actualError: actualError,
        );
}
