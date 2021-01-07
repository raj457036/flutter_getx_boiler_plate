import 'dart:convert' show json;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/core.dart';
import 'app/core/translations/translations.dart';
import 'app/global/global.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_route_observer.dart';
import 'app/utils/function/di.dart';
import 'generated/locales.g.dart';

class Model extends CachebleModel<Model> with EquatableMixin {
  final String id;
  final String name;

  final int timestamp;

  Model({
    @required this.id,
    @required this.name,
    @required this.timestamp,
  });

  factory Model.fromCache([String id]) {
    return Model(id: id, name: null, timestamp: null);
  }

  Model copyWith({
    String id,
    String name,
    int timestamp,
  }) {
    return Model(
      id: id ?? this.id,
      name: name ?? this.name,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timestamp': timestamp,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Model(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Model.fromJson(String source) => Model.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, timestamp];

  @override
  String get key => id;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DI.instance.init();
  GlobalTranslation.I.setup(AppTranslation.translations);
  await CacheServiceModule.init(cachebleModels: [Model]);

  LogService.I.enableColor = true;
  // LogService.I.enableSeperator = true;
  // LogService.I.enableSeperatorSpace = true;

  LogService.normal("Normal");
  LogService.debug("Debug");
  LogService.config("Config");
  LogService.info("Info");
  LogService.error("Severe");
  LogService.shout("Shout");
  LogService.warning("Warning");

  Model.fromCache("1234").listenThis(
    (_) => print(_),
    modelFactory: (_) => Model.fromMap(_),
  );
  Model.fromCache("1234").listenThis(
    (_) => print(_.id),
    modelFactory: (_) => Model.fromMap(_),
  );

  await Model(id: "1234", name: "Raj SIngh dsfa sdfs afsd", timestamp: 12345678)
      .save();

  final data =
      Model.fromCache().fetchAll(modelFactory: (_) => Model.fromMap(_));

  await Model(id: "1234", name: "Raj Singh", timestamp: 12345678).save();

  print(data);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: [AppRouteObserver.instance],
      locale: Locale('en', "US"),
      translations: GlobalTranslation.I,
    ),
  );
}
