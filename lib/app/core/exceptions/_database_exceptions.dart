part of 'exceptions.dart';

class DatabaseException extends BaseException {
  const DatabaseException({
    String? message,
    actualError,
  }) : super(
          message: message ?? "database exception encounterd",
          actualError: actualError,
        );
}
