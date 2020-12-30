import 'dart:convert';
import 'dart:developer';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show rootBundle;

part '_colors.dart';
part '_values.dart';
part '_environments.dart';

class Env {
  final _ColorStyles _colorStyles = _ColorStyles();
  final _Values _values = _Values();
  final _Environment _environment = _Environment();

  Env._();

  static final Env _instance = Env._();

  static Env get instance => _instance;
  static _ColorStyles get colors => instance._colorStyles;
  static _Values get values => instance._values;
  static _Environment get environment => instance._environment;

  Future<void> init() async {
    await environment.loadEnvironment();
  }
}
