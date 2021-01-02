part '_database_exceptions.dart';
part '_general_exceptions.dart';
part '_network_exceptions.dart';

class BaseException implements Exception, Type {
  final String message;
  final actualError;

  const BaseException({this.message, this.actualError});
}
