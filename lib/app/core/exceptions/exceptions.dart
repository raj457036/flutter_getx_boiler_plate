part '_database_exceptions.dart';
part '_general_exceptions.dart';
part '_network_exceptions.dart';

class BaseException implements Exception {
  final String message;
  final Exception actualError;

  const BaseException({this.message, this.actualError});
}
