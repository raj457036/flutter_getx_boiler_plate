import 'dart:developer';

class LogLevel {
  LogLevel._();

  static const int NORMAL = 0;
  static const int DEBUG = 500;
  static const int CONFIG = 700;
  static const int INFO = 800;
  static const int WARNING = 200;
  static const int ERROR = 1000;
  static const int SHOUT = 1200;
}

typedef bool LogConditionChecker({int level, Object error});
typedef void LogWriter(
  String message, {
  String name,
  int level,
  Object error,
  DateTime time,
});

class AnsiTextColorizer {
  static const ansiEsc = '\x1B[';

  static const ansiDefault = '${ansiEsc}0m';

  final int fg;
  final int bg;
  final bool color;

  AnsiTextColorizer.none()
      : fg = null,
        bg = null,
        color = false;

  AnsiTextColorizer.fg(this.fg)
      : bg = null,
        color = true;

  AnsiTextColorizer.bg(this.bg)
      : fg = null,
        color = true;

  AnsiTextColorizer.color(this.fg, this.bg) : color = true;

  @override
  String toString() {
    if (fg != null) {
      return '${ansiEsc}38;5;${fg}m';
    } else if (bg != null) {
      return '${ansiEsc}48;5;${bg}m';
    } else {
      return '';
    }
  }

  String call(String msg) {
    if (color) {
      final _result = '${this}$msg$ansiDefault';
      if (bg != null && fg != null) {
        final AnsiTextColorizer _bg = AnsiTextColorizer.bg(bg);
        return _bg(_result);
      }
      return _result;
    } else {
      return msg;
    }
  }

  AnsiTextColorizer toFg() => AnsiTextColorizer.fg(bg);

  AnsiTextColorizer toBg() => AnsiTextColorizer.bg(fg);

  String get resetForeground => color ? '${ansiEsc}39m' : '';

  String get resetBackground => color ? '${ansiEsc}49m' : '';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}

class LogService {
  LogService._();

  static LogService _instance = LogService._();
  static LogService get instance => _instance;
  static LogService get I => _instance;

  final _colorizer = {
    LogLevel.NORMAL: AnsiTextColorizer.fg(7),
    LogLevel.DEBUG: AnsiTextColorizer.fg(2),
    LogLevel.CONFIG: AnsiTextColorizer.fg(6),
    LogLevel.INFO: AnsiTextColorizer.fg(4),
    LogLevel.ERROR: AnsiTextColorizer.fg(1),
    LogLevel.SHOUT: AnsiTextColorizer.fg(5),
    LogLevel.WARNING: AnsiTextColorizer.fg(3),
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
  LogWriter _writer;
  bool enableColor = true;
  bool enableSeperator = false;
  bool enableSeperatorSpace = false;

  static write(String message, {int level, Object error}) {
    for (var checker in _instance._checkers) {
      if (!checker(error: error, level: level)) return;
    }
    final _level = level ?? LogLevel.NORMAL;
    final _name = _instance._names[_level];

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
        _msg,
        name: _name,
        level: _level,
        error: error,
        time: DateTime.now(),
      );
    else
      log(
        _msg,
        name: _name,
        time: DateTime.now(),
        level: _level,
        error: error,
      );
  }

  static debug(String message, {Object error}) =>
      write(message, level: LogLevel.DEBUG, error: error);
  static error(String message, {Object error}) =>
      write(message, level: LogLevel.ERROR, error: error);
  static warning(String message, {Object error}) =>
      write(message, level: LogLevel.WARNING, error: error);
  static info(String message, {Object error}) =>
      write(message, level: LogLevel.INFO, error: error);
  static shout(String message, {Object error}) =>
      write(message, level: LogLevel.SHOUT, error: error);
  static config(String message, {Object error}) =>
      write(message, level: LogLevel.CONFIG, error: error);

  setConditions(List<LogConditionChecker> checkers) =>
      _checkers = checkers ?? const [];

  setLogWriter(LogWriter writer) => _writer = writer;
  setName(String name, int level) => _names[level] = name;
  setColor(AnsiTextColorizer color, int level) => _colorizer[level] = color;
}
