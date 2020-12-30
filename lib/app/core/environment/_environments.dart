part of 'env.dart';

const Map<String, dynamic> _prodEnv = const <String, dynamic>{};
const Map<String, dynamic> _devEnv = const <String, dynamic>{};

enum Environment {
  production,
  development,
}

class _Environment {
  bool _initialized = false;

  final Map<dynamic, dynamic> _flavours = <dynamic, dynamic>{
    Environment.production: _prodEnv,
    Environment.development: _devEnv,
  };

  bool get isProductionMode => const bool.fromEnvironment('dart.vm.product');
  bool get isDevelopmentMode => !isProductionMode;

  Future<void> loadEnvironment({String path, bool force = false}) async {
    try {
      final _source = await rootBundle.loadString(
        path ?? "assets/secrets/secrets.json",
        cache: !force,
      );

      final _parsedData = Map.from(json.decode(_source));

      _flavours[Environment.production] = {
        _parsedData['production'],
        _flavours[Environment.production]
      };
      _flavours[Environment.development] = {
        _parsedData['development'],
        _flavours[Environment.development]
      };
      _initialized = true;
    } catch (e) {
      log("Error occured while fetching enviorments from asset folder: $e");
    }
  }

  T config<T>(String key, {Environment overried, dynamic defaultValue}) {
    if (!_initialized)
      log("Enviroment variables are not initilaized. call Env.instance.init() in main");

    if (overried != null) return _flavours[overried][key];

    if (isDevelopmentMode) return _flavours[Environment.development][key];
    if (isProductionMode) return _flavours[Environment.production][key];

    if (defaultValue != null) return defaultValue;

    throw Exception("Environment Exception: $key not found");
  }
}
