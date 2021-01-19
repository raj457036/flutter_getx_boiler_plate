import 'dart:developer';

import 'src/log_colorizer.dart';
import 'src/log_levels.dart';
import 'src/log_load.dart';
import 'src/log_writer.dart';

export 'src/log_writer.dart';
export 'src/log_levels.dart';
export 'src/log_colorizer.dart';
export 'src/log_load.dart';

typedef bool LogConditionChecker({int level, Object errorObj});
typedef void LogPrinter(
  String message, {
  String name,
  int level,
  Object errorObj,
  DateTime time,
});

class LogService {
  LogService._();

  static LogService _instance = LogService._();
  static LogService get instance => _instance;
  static LogService get I => _instance;

  factory LogService.newInstance() => LogService._();

  final _colorizer = {
    LogLevel.NORMAL: LogTextColorizer.fg(7),
    LogLevel.DEBUG: LogTextColorizer.fg(2),
    LogLevel.CONFIG: LogTextColorizer.fg(6),
    LogLevel.INFO: LogTextColorizer.fg(4),
    LogLevel.ERROR: LogTextColorizer.fg(1),
    LogLevel.SHOUT: LogTextColorizer.fg(5),
    LogLevel.WARNING: LogTextColorizer.fg(3),
  };

  final _names = {
    LogLevel.NORMAL: 'NORMAL',
    LogLevel.DEBUG: 'DEBUG',
    LogLevel.CONFIG: 'CONFIG',
    LogLevel.INFO: 'INFO',
    LogLevel.ERROR: 'ERROR',
    LogLevel.SHOUT: 'SHOUT',
    LogLevel.WARNING: 'WARNING',
  };

  List<LogConditionChecker> _checkers = const [];
  LogPrinter _writer;
  bool enableColor = true;
  bool enableSeperator = false;
  bool enableSeperatorSpace = false;
  LogWriter writer;

  static write(LogLoad load) {
    for (var checker in _instance._checkers) {
      if (!checker(errorObj: load.error, level: load.level)) return;
    }
    final _level = load.level ?? LogLevel.NORMAL;
    final _name = _instance._names[_level];
    final _timestamp = DateTime.now();

    var message = load.message;

    if (_instance.writer != null) {
      _instance.writer.write(load, _name, _timestamp);
    }

    if (_instance.enableSeperator == true) {
      message =
          "---------- $_name ----------\n$message\n---------- $_name ----------";

      if (_instance.enableSeperatorSpace == true) message = "\n$message\n";
    }

    final _msg = _instance.enableColor != true
        ? message
        : instance._colorizer[_level](message);

    if (_instance._writer != null)
      _instance._writer(
        _msg.toString(),
        name: _name,
        level: _level,
        errorObj: load.error,
        time: _timestamp,
      );
    else
      log(
        _msg.toString(),
        name: _name,
        time: _timestamp,
        level: _level,
        error: load.error,
      );
  }

  static normal(Object message, {Object errorObj}) =>
      write(LogLoad(message, level: LogLevel.NORMAL, error: errorObj));
  static debug(Object message, {Object errorObj}) =>
      write(LogLoad(message, level: LogLevel.DEBUG, error: errorObj));
  static error(Object message, {Object errorObj}) =>
      write(LogLoad(message, level: LogLevel.ERROR, error: errorObj));
  static warning(Object message, {Object errorObj}) =>
      write(LogLoad(message, level: LogLevel.WARNING, error: errorObj));
  static info(Object message, {Object errorObj}) =>
      write(LogLoad(message, level: LogLevel.INFO, error: errorObj));
  static shout(Object message, {Object errorObj}) =>
      write(LogLoad(message, level: LogLevel.SHOUT, error: errorObj));
  static config(Object message, {Object errorObj}) =>
      write(LogLoad(message, level: LogLevel.CONFIG, error: errorObj));

  setConditions(List<LogConditionChecker> checkers) =>
      _checkers = checkers ?? const [];

  setLogWriter(LogPrinter writer) => _writer = writer;
  setName(String name, int level) => _names[level] = name;
  setColor(LogTextColorizer color, int level) => _colorizer[level] = color;
}
