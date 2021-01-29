part of 'exceptions.dart';

class GeneralException extends BaseException {
  const GeneralException({
    String message,
    actualError,
  }) : super(
          message: message ?? "some exception encounterd",
          actualError: actualError,
        );
}

class AssetLoadFailedException extends GeneralException {
  AssetLoadFailedException(Exception actualError)
      : super(
          actualError: actualError,
          message: "Asset could not be loaded: $actualError",
        );
}

class TranslationLoadFailedException extends GeneralException {
  TranslationLoadFailedException()
      : super(
          message: "translation could not be loaded",
        );
}

class EnvironmentException extends GeneralException {
  EnvironmentException(String message) : super(message: message);
}
