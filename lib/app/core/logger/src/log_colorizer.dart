class LogTextColorizer {
  static const ansiEsc = '\x1B[';

  static const ansiDefault = '${ansiEsc}0m';

  final int fg;
  final int bg;
  final bool color;

  LogTextColorizer.none()
      : fg = null,
        bg = null,
        color = false;

  LogTextColorizer.fg(this.fg)
      : bg = null,
        color = true;

  LogTextColorizer.bg(this.bg)
      : fg = null,
        color = true;

  LogTextColorizer.color(this.fg, this.bg) : color = true;

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
        final LogTextColorizer _bg = LogTextColorizer.bg(bg);
        return _bg(_result);
      }
      return _result;
    } else {
      return msg;
    }
  }
}
