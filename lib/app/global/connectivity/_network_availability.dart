part of 'connectivity_module.dart';

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

class InternetConnectionChecker implements NetworkAvailablity {
  InternetConnectionChecker._();
  static InternetConnectionChecker _instance = InternetConnectionChecker._();
  static InternetConnectionChecker get instance => _instance;

  static InternetConnectionChecker get I => instance;

  InternetConnectionCondition _precheck, _postcheck;
  List<AddressOption> _options = [
    AddressOption(address: InternetAddress("1.1.1.1"))
  ];

  static void setAddressOptions(List<AddressOption> options) {
    I._options = [I._options.first, ...(options ?? [])];
  }

  static void setPreAndPostChecks({
    InternetConnectionCondition precheck,
    InternetConnectionCondition postcheck,
  }) {
    I._precheck = precheck;
    I._postcheck = postcheck;
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
      LogService.write(
        "No internet available: $_",
        level: LogLevel.INFO,
      );

      isConnected = false;
    } on TimeoutException catch (_) {
      LogService.write(
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
      LogService.write(
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
      LogService.write(
        "Internet connection test: Post-check condition failed",
        level: LogLevel.INFO,
      );
      isConnected = false;
    }
    return isConnected;
  }
}