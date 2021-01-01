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

class Log {
  const Log._();

  static write(String message, {int level, Object error}) {
    log(
      message,
      time: DateTime.now(),
      level: level ?? LogLevel.ALL,
      error: error,
    );
  }
}
