import 'package:get_storage/get_storage.dart';

import '../../../core/core.dart';
import '../../../core/logger/logger.dart';

class CacheServiceModule {
  CacheServiceModule._();
  static CacheServiceModule _instance = CacheServiceModule._();
  static CacheServiceModule get instance => _instance;

  static Set<String> _boxes = {};

  bool _initialized = false;

  GetStorage box({String name, Map<String, dynamic> initialData}) {
    if (!_initialized)
      throw DatabaseException(
        message: "CacheServiceModule is not initialized yet."
            " consider calling CacheServiceModule.init() in main",
      );

    if (name == null) return GetStorage("GetStorage", null, initialData);
    if (!_boxes.contains(name)) {
      LogService.warning("Box $name not initialized");
      return null;
    }
    return GetStorage(name, null, initialData);
  }

  static Future<void> init(
      {List<String> boxes = const [],
      List<Type> cachebleModels = const []}) async {
    _boxes.addAll([
      ...boxes,
      ...cachebleModels.map(
        (e) => e.toString(),
      )
    ]);

    final _initFuture = [
      GetStorage.init(),
      ..._boxes.map(
        (boxName) => GetStorage.init(boxName),
      ),
    ];

    await Future.wait(
      _initFuture,
    );

    _instance._initialized = true;
  }

  initIfNotExists(String name) async {
    if (!_boxes.contains(name)) {
      await GetStorage.init(name);
      _boxes.add(name);
    }
  }

  Future<void> erase(String name) async {
    if (!_boxes.contains(name)) return;
    await box(name: name).erase();
  }

  Future<void> eraseAll() async {
    final _initFuture = [
      GetStorage().erase(),
      ..._boxes.map(
        (boxName) => GetStorage(boxName).erase(),
      ),
    ];

    await Future.wait(_initFuture);
  }
}
