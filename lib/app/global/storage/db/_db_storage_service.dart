import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class DbStorageService extends GetxService {
  DbStorageService._();
  static DbStorageService get instance => Get.find<DbStorageService>();

  String _path;
  String get path => _path;

  _init({
    String path,
  }) async {
    if (initialized) return;
    var databasesPath = await getDatabasesPath();
    _path = [databasesPath, '_base_database_1.db'].join("/");
  }

  static init({
    String path,
  }) {
    final _i = DbStorageService._();
    _i._init(path: path);
    Get.put(_i);
  }

  eraseAll() async {
    await deleteDatabase(path);
  }
}
