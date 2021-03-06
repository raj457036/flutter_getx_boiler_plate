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
      final _source = await AssetLoader.instance.loadString(
        path,
        fromCache: !force,
      );

      final _parsedData = Map.from(json.decode(_source));

      _flavours[Environment.production] = <dynamic, dynamic>{
        ..._parsedData['production'],
        ..._flavours[Environment.production]
      };
      _flavours[Environment.development] = <dynamic, dynamic>{
        ..._parsedData['development'],
        ..._flavours[Environment.development]
      };
      _initialized = true;
    } catch (e) {
      LogService.warning(
          "Error occured while fetching enviorments from asset folder: $e");
    }
  }

  T config<T>(String key,
      {Environment overried, dynamic defaultValue, bool silent = false}) {
    if (!_initialized)
      LogService.warning(
          "Enviroment variables are not initilaized. call Env.instance.init() in main");

    if (overried != null) {
      final val = _flavours[overried][key];
      if (val == null)
        LogService.warning("$key not found in $overried environment.");
      return val;
    }

    if (isDevelopmentMode) {
      final val = _flavours[Environment.development][key];
      if (val == null)
        LogService.warning("$key not found in development environment.\n"
            "Add $key to assets/secrets -> development");
      else
        return val;
    }
    if (isProductionMode) {
      final val = _flavours[Environment.production][key];
      if (val == null)
        LogService.warning(
          "$key not found in production environment.\n"
          " Add $key to assets/secrets -> production",
        );
      else
        return val;
    }

    if (defaultValue != null) return defaultValue;

    if (!silent)
      throw EnvironmentException("$key not found in your environment.");
    return null;
  }
}
