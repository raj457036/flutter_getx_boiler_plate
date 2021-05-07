import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '_db_storage_service.dart';

const Set<String> RESTRICTED_KEYS = const {
  "add",
  "all",
  "alter",
  "and",
  "as",
  "autoincrement",
  "between",
  "case",
  "check",
  "collate",
  "commit",
  "constraint",
  "create",
  "default",
  "deferrable",
  "delete",
  "distinct",
  "drop",
  "else",
  "escape",
  "except",
  "exists",
  "foreign",
  "from",
  "group",
  "having",
  "if",
  "in",
  "index",
  "insert",
  "intersect",
  "into",
  "is",
  "isnull",
  "join",
  "limit",
  "not",
  "notnull",
  "null",
  "on",
  "or",
  "order",
  "primary",
  "references",
  "select",
  "set",
  "table",
  "then",
  "to",
  "transaction",
  "union",
  "unique",
  "update",
  "using",
  "values",
  "when",
  "where"
};

bool getDbBool(int value) => value < 1 ? false : true;
DateTime getDbDate(int millisecondsSinceEpoch) =>
    DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

abstract class DbTableBinder {
  int __id;
  int get pk => __id;

  DbTableBinder(int id) : __id = id;

  bool _hasForeignKey = false;

  String getTableName() {
    return runtimeType.toString();
  }

  Set<String> get primaryKeys => Set();
  Set<String> get notNullable => Set();

  Map<String, dynamic> toMap();

  List<DbColumnBinder> getTableSchema() {
    final _source = toMap();

    final columns = [
      DbColumnBinder(
        name: "__id",
        isPrimary: true,
        type: "INTEGER",
        notNullable: false,
        rawValue: pk,
      ),
    ];

    for (var entry in _source.entries) {
      assert(
        !RESTRICTED_KEYS.contains(entry.key),
        "$entry is not a valid column. reason: using restricted key name.",
      );

      String _type;

      bool _isBool = false;
      bool _isDate = false;

      if (entry.value is int) {
        _type = "INTEGER";
      } else if (entry.value is double) {
        _type = "REAL";
      } else if (entry.value is String) {
        _type = "TEXT";
      } else if (entry.value is Uint8List) {
        _type = "BLOB";
      } else if (entry.value is bool) {
        _type = "INTEGER";
        _isBool = true;
      } else if (entry.value is DateTime) {
        _type = "INTEGER";
        _isDate = true;
      } else {
        _type = "ANY";
      }

      final column = DbColumnBinder(
        name: entry.key,
        type: _type,
        isPrimary: primaryKeys.contains(entry.key),
        notNullable: notNullable.contains(entry.key),
        isBool: _isBool,
        isDate: _isDate,
        rawValue: entry.value,
      );

      columns.add(column);
    }

    return columns;
  }

  String _toCreateQuery() {
    String _tableName = getTableName();

    final String columnQuery = getTableSchema()
        .map(
          (column) => column.toCreateQuery(),
        )
        .join(",");

    final String query =
        "CREATE TABLE IF NOT EXISTS $_tableName ($columnQuery);";
    return query;
  }

  Map<String, dynamic> _toInsertMap() {
    var map = <String, dynamic>{};

    for (var column in getTableSchema()) {
      map[column.name] = column.value;
    }

    return map;
  }
}

class DbColumnBinder extends Equatable {
  final String name;
  final bool isPrimary;
  final String type;
  final bool notNullable;
  final bool autoIncrement;
  final bool isBool;
  final bool isDate;
  final dynamic rawValue;

  const DbColumnBinder({
    required this.name,
    required this.isPrimary,
    required this.type,
    required this.notNullable,
    this.autoIncrement = false,
    this.isBool = false,
    this.isDate = false,
    this.rawValue,
  });

  String toCreateQuery() {
    String query = "$name $type";
    if (isPrimary) query = "$query PRIMARY KEY";
    if (!notNullable) query = "$query NOT NULL";
    if (autoIncrement) query = "$query AUTOINCREMENT";
    return query;
  }

  get value {
    if (!notNullable && rawValue == null) return null;
    if (isBool) return rawValue == true ? 1 : 0;
    if (isDate) return (rawValue as DateTime).millisecondsSinceEpoch;
    return rawValue;
  }

  @override
  List<Object> get props => [name];
}

abstract class DbBinder<T> extends DbTableBinder {
  static late Database _db;

  DbBinder({required int id}) : super(id);

  T fromMap(Map<String, dynamic>? map);

  Future<DbBinder<T>> open(
      {String? path, int? version, bool readOnly = false}) async {
    final database = await openDatabase(
      path ?? DbStorageService.instance.path,
      version: version ?? 1,
      onCreate: (Database db, int version) async {
        final query = _toCreateQuery();

        if (_hasForeignKey) await db.execute('PRAGMA foreign_keys = ON');

        await db.execute(query);
      },
      readOnly: readOnly,
    );
    _db = database;
    return this;
  }

  Future<int> insert() async {
    __id = await _db.insert(getTableName(), _toInsertMap());
    return __id;
  }

  Future<List<T>?> fetch({
    Map<String, Object?>? query,
    bool? all,
    bool? distinct,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    final _where = query?.keys.map((key) => "$key = ?").toList().join(",");

    final _whereArgs = query?.values.toList();

    List<Map> maps = await _db.query(
      getTableName(),
      where: all == true ? null : (_where ?? '__id = ?'),
      whereArgs: all == true ? null : (_whereArgs ?? [pk]),
      distinct: distinct,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );

    return maps.map((row) => fromMap(row as Map<String, dynamic>)).toList();
  }

  Future<int> delete() async {
    return await _db.delete(getTableName(), where: '__id = ?', whereArgs: [pk]);
  }

  Future<int> update() async {
    return await _db.update(getTableName(), this.toMap(),
        where: '__id = ?', whereArgs: [pk]);
  }

  Future close() async => await _db.close();
}
