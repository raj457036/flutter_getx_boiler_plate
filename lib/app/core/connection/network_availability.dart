import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';

import '../../utils/function/logger.dart';

abstract class NetworkAvailablity {
  Future<bool> get isAvailable;

  Future<T> executeWhenAvailable<T>({
    @required Future<T> Function() callback,
    @required Future<T> Function() orElse,
  });
}

typedef Future<bool> InternetConnectionCondition();

class AddressOption {
  final InternetAddress address;
  final int port;
  final int timeoutSeconds;

  AddressOption({
    @required this.address,
    this.port = 53,
    this.timeoutSeconds = 3,
  });
}

class InternetConnection implements NetworkAvailablity {
  InternetConnection._();
  static InternetConnection _instance = InternetConnection._();
  static InternetConnection get instance => _instance;
  static InternetConnection get I => _instance;

  InternetConnectionCondition _precheck, _postcheck;
  List<AddressOption> _options = [
    AddressOption(address: InternetAddress("1.1.1.1"))
  ];

  static void setAddressOptions(List<AddressOption> options) {
    _instance._options = [_instance._options.first, ...(options ?? [])];
  }

  static void setPreAndPostChecks({
    InternetConnectionCondition precheck,
    InternetConnectionCondition postcheck,
  }) {
    _instance._precheck = precheck;
    _instance._postcheck = postcheck;
  }

  @override
  Future<T> executeWhenAvailable<T>({
    @required Future<T> Function() callback,
    @required Future<T> Function() orElse,
  }) async {
    if (await isAvailable)
      return await callback();
    else
      return orElse();
  }

  @override
  Future<bool> get isAvailable async => await _checkForActiveConnection();

  // private methods
  Future<bool> _hostAvailable(AddressOption option) async {
    final timeout = !(option.timeoutSeconds?.isNegative ?? true)
        ? option.timeoutSeconds
        : 0;

    Socket socket;
    bool isConnected = false;
    try {
      // ignore: close_sinks
      socket = await Socket.connect(
        option.address,
        option.port,
        timeout: Duration(
          seconds: timeout,
        ),
      );
      isConnected = true;
    } on SocketException catch (_) {
      Log.write(
        "No internet available: $_",
        level: LogLevel.INFO,
      );

      isConnected = false;
    } on TimeoutException catch (_) {
      Log.write(
        "Internet check timeout after $timeout seconds",
        level: LogLevel.INFO,
      );
      isConnected = false;
    } finally {
      socket?.destroy();
    }
    return isConnected;
  }

  Future<bool> _checkForActiveConnection() async {
    if (_precheck != null && !await _precheck()) {
      Log.write(
        "Internet connection test: Pre-check condition failed",
        level: LogLevel.INFO,
      );
      return false;
    }

    bool isConnected;

    final List<Future<bool>> futureChecks = [];

    for (var option in _options) {
      futureChecks.add(_hostAvailable(option));
    }

    isConnected = (await Future.wait(futureChecks)).contains(true);

    if (_postcheck != null && !await _postcheck()) {
      Log.write(
        "Internet connection test: Post-check condition failed",
        level: LogLevel.INFO,
      );
      isConnected = false;
    }
    return isConnected;
  }
}
