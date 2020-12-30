part of 'exceptions.dart';

class DatabaseException extends BaseException {
  const DatabaseException({
    String message,
    Exception actualError,
  }) : super(
          message: message ?? "database exception encounterd",
          actualError: actualError,
        );
}
