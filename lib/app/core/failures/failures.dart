import '../../../generated/locales.g.dart';

part '_database_failures.dart';
part '_general_failures.dart';
part '_network_failures.dart';

// ERROR CODE STARTING WITH 999xxx are for external modules
class Failure implements Type {
  final int code;
  final String message;
  final Object actualException;

  const Failure({this.code, this.message, this.actualException});
}
