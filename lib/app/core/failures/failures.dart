import 'package:get/get.dart';

part '_database_failures.dart';
part '_general_failures.dart';
part '_network_failures.dart';

class Failure implements Type {
  final int code;
  final String message;
  final Exception actualException;

  const Failure({this.code, this.message, this.actualException});
}
