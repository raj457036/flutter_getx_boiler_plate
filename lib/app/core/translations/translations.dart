import 'dart:convert';

import 'package:get/get.dart';

import '../../utils/function/asset_loader.dart';
import '../../utils/function/logger.dart';
import '../core.dart';

class GlobalTranslation extends Translations {
  GlobalTranslation._();

  Map<String, Map<String, String>> _translations =
      Map<String, Map<String, String>>();

  static GlobalTranslation _instance = GlobalTranslation._();

  static GlobalTranslation get instance => _instance;

  @override
  Map<String, Map<String, String>> get keys {
    if (_translations == null) {
      Log.write(
        "call GlobalTranlation.setup first in main.dart file",
        level: LogLevel.CONFIG,
      );
      throw TranslationLoadFailedException();
    }

    return _translations;
  }

  Future<Map<String, String>> jsonParser(String source) async {
    return Map<String, String>.from(json.decode(source));
  }

  static setup(Map<String, String> translationFilesPath) async {
    final keys = translationFilesPath.keys;
    final loader = AssetLoader.instance;

    final Map<String, Map<String, String>> tempTranslations =
        Map<String, Map<String, String>>();

    for (var key in keys) {
      final path = translationFilesPath[key];
      try {
        final translations =
            await loader.loadStructuredData<Map<String, String>>(
          path,
          parser: instance.jsonParser,
        );

        tempTranslations[key] = translations;
      } catch (e) {
        Log.write(
          "$key: translation couldn't be parsed",
          error: e,
          level: LogLevel.SEVERE,
        );
      }
    }

    instance._translations = tempTranslations;
  }
}
