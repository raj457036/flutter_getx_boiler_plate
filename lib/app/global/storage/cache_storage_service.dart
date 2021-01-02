import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/function/logger.dart';

class CacheService extends GetxService {
  CacheService._();
  static CacheService get instance => Get.find<CacheService>();
  static CacheService get I => instance;

  static Set<String> _boxes = {};

  GetStorage box({String name, Map<String, dynamic> initialData}) {
    if (name == null) return GetStorage("GetStorage", null, initialData);
    if (!_boxes.contains(name)) {
      Log.write("Box $name not initialized");
      return null;
    }
    return GetStorage(name, null, initialData);
  }

  static init([List<String> boxes = const []]) async {
    Get.lazyPut<CacheService>(() => CacheService._());

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
