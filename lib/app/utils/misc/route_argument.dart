import 'dart:collection';

import 'package:get/get.dart';

class RouteArguments {
  final Map<String, dynamic> _data;

  const RouteArguments([this._data = const {}]);

  T get<T>(String key, {T? defaultValue}) => _data[key] ?? defaultValue;

  Map<String, dynamic> get raw => {..._data};

  static RouteArguments get current {
    final args = Get.arguments;
    if (args != null) {
      if (args is RouteArguments) return args;
      if (args is LinkedHashMap) return RouteArguments(Map.from(args));
      return RouteArguments({"data": args});
    }
    return RouteArguments();
  }
}

class RouteParameters {
  final Map<String, dynamic> _data;

  const RouteParameters([this._data = const {}]);

  T get<T>(String key, {T? defaultValue}) => _data[key] ?? defaultValue;

  Map<String, dynamic> get raw => {..._data};

  static RouteParameters get current {
    final args = Get.parameters;
    return RouteParameters(Map.from(args));
  }
}
