class LogLevel {
  LogLevel._();

  static const int NORMAL = 0;
  static const int DEBUG = 500;
  static const int CONFIG = 700;
  static const int INFO = 800;
  static const int WARNING = 200;
  static const int ERROR = 1000;
  static const int SHOUT = 1200;

  static const Set<int> ALL = const {
    NORMAL,
    DEBUG,
    CONFIG,
    INFO,
    WARNING,
    ERROR,
    SHOUT
  };
}
