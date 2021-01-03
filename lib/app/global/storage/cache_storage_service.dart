import 'package:get_storage/get_storage.dart';

import '../../core/core.dart';
import '../../utils/function/logger.dart';

class CacheServiceModule {
  CacheServiceModule._();
  static CacheServiceModule _instance = CacheServiceModule._();
  static CacheServiceModule get instance => _instance;

  static Set<String> _boxes = {};

  bool _initialized = false;

  GetStorage box({String name, Map<String, dynamic> initialData}) {
    if (!_initialized)
      throw BaseException(
        message: "CacheServiceModule is not initialized yet.",
      );

    if (name == null) return GetStorage("GetStorage", null, initialData);
    if (!_boxes.contains(name)) {
      LogService.write("Box $name not initialized");
      return null;
    }
    return GetStorage(name, null, initialData);
  }

  static init([List<String> boxes = const []]) async {
    _boxes.addAll([...(boxes ?? const [])]);

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
