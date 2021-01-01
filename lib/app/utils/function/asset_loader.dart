import 'package:flutter/services.dart' show rootBundle;
import 'package:meta/meta.dart';

import '../../core/core.dart';
import 'logger.dart';

class AssetLoader {
  AssetLoader._();

  static AssetLoader _instance = AssetLoader._();
  static AssetLoader get instance => _instance;

  Future<String> loadString(String fileName,
      {bool fromCache = true, bool elseNull = false}) async {
    try {
      final _source = await rootBundle.loadString(
        "assets/$fileName",
        cache: fromCache,
      );
      return _source;
    } catch (e) {
      Log.write(
        "Error occured while fetching asset at path: $fileName",
        level: LogLevel.WARNING,
        error: e,
      );
      if (elseNull) return null;
      throw AssetLoadFailedException(e);
    }
  }

  Future<T> loadStructuredData<T>(
    String fileName, {
    bool fromCache = true,
    bool elseNull = false,
    @required Future<T> Function(String) parser,
  }) async {
    try {
      final T _source = await rootBundle.loadStructuredData<T>(
        "assets/$fileName",
        parser,
      );
      return _source;
    } catch (e) {
      Log.write(
        "Error occured while fetching asset at path: $fileName",
        level: LogLevel.WARNING,
        error: e,
      );
      if (elseNull) return null;
      throw AssetLoadFailedException(e);
    }
  }
}
