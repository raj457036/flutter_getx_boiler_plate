import 'dart:developer';

class LogLevel {
  LogLevel._();

  static const int ALL = 0;
  static const int FINEST = 300;
  static const int FINER = 400;
  static const int FINE = 500;
  static const int CONFIG = 700;
  static const int INFO = 800;
  static const int WARNING = 200;
  static const int SEVERE = 1000;
  static const int SHOUT = 1200;
  static const int OFF = 2000;
}

typedef bool LogConditionChecker({int level, Object error});
typedef void LogWriter(
  String message, {
  String name,
  int level,
  Object error,
  DateTime time,
});

class Log {
  Log._();

  static Log _instance = Log._();
  static Log get instance => _instance;
  static Log get I => _instance;

  List<LogConditionChecker> _checkers = const [];
  LogWriter _writer;
  String _name;

  static write(String message, {int level, Object error}) {
    for (var checker in _instance._checkers) {
      if (!checker(error: error, level: level)) return;
    }

    if (_instance._writer != null)
      _instance._writer(
        message,
        name: _instance._name,
        level: level,
        error: error,
        time: DateTime.now(),
      );
    else
      log(
        message,
        name: _instance._name ?? '',
        time: DateTime.now(),
        level: level ?? LogLevel.ALL,
        error: error,
      );
  }

  setConditions(List<LogConditionChecker> checkers) =>
      _checkers = checkers ?? const [];

  setLogWriter(LogWriter writer) => _writer = writer;
  setName(String name) => _name = name;
}
