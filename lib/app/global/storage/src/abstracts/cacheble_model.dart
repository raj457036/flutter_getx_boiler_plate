import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

import '../../../../core/core.dart';
import '../cache_storage_service.dart';

typedef T ModelMapFactory<T>(Map<String, dynamic> source);

abstract class CachebleModel<T extends CachebleModel<T>>
    extends BaseModel<CachebleModel> {
  String get key;

  Future<void> save() async {
    final CacheServiceModule _cacheService = CacheServiceModule.instance;
    String boxName = runtimeType.toString();

    await _cacheService.initIfNotExists(boxName);
    final box = _cacheService.box(name: boxName);

    final load = toMap();

    await box.write(key, load);
  }

  GetStorage _getBox() {
    final CacheServiceModule _cacheService = CacheServiceModule.instance;
    String boxName = runtimeType.toString();
    try {
      final GetStorage box = _cacheService.box(name: boxName);
      return box;
    } catch (e) {
      LogService.info("$boxName Cache not found!");
    }
    return null;
  }

  T fetch<T extends CachebleModel<T>>({
    @required ModelMapFactory<T> modelFactory,
  }) {
    final GetStorage box = _getBox();
    if (box == null) return null;

    final load = box.read<Map<String, dynamic>>(key);

    return modelFactory(load);
  }

  List<T> fetchAll<T extends CachebleModel<T>>({
    @required ModelMapFactory<T> modelFactory,
  }) {
    final GetStorage box = _getBox();
    if (box == null) return null;

    final values = List<Map<String, dynamic>>.from(box.getValues())
        .map((load) => modelFactory(load))
        .toList();
    return values;
  }

  Future<void> erase() async {
    final GetStorage box = _getBox();
    if (box == null) return null;
    await box.remove(key);
  }

  Future<void> eraseAll() async {
    final GetStorage box = _getBox();
    if (box == null) return null;
    await box.erase();
  }

  void listenThis(
    Function(T) listener, {
    @required ModelMapFactory<T> modelFactory,
  }) async {
    GetStorage box = _getBox();
    box?.listenKey(key, (_) => listener(modelFactory(_)));
  }

  void listenAll(void Function() listener) async {
    GetStorage box = _getBox();
    box?.listen(listener);
  }
}
