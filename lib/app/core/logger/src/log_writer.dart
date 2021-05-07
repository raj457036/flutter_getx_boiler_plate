import 'log_load.dart';

typedef String LogFormatter(LogLoad load, String? logger, DateTime timestamp);

abstract class LogWriter {
  final String name;
  final Set<int> levels;
  final LogFormatter? logFormatter;

  /// Extends this class to create your custom log writer
  ///
  /// **For example**: one which saves the logs to the server or saves the logs in
  /// users device
  LogWriter(
    this.name,
    this.levels, {
    this.logFormatter,
  });

  /// returns a nicly formatted log String
  String formatter(
    LogLoad load,
    String? logger,
    DateTime timestamp,
  ) {
    if (logFormatter != null) return logFormatter!(load, logger, timestamp);

    final String _time = timestamp.toLocal().toIso8601String();
    final String _logger = logger ?? '[LOG]';
    final String _msg = load.message.toString();
    final _text = '$_logger <$_time> $_msg\n';
    return _text;
  }

  Future<void> write(
    LogLoad load,
    String? logger,
    DateTime timestamp,
  );
}
