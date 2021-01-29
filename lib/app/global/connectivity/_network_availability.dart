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

  InternetConnectionCondition _precheck, _postcheck;
  List<AddressOption> _options = [
    AddressOption(address: InternetAddress("1.1.1.1"))
  ];

  static void setAddressOptions(List<AddressOption> options) {
    instance._options = [instance._options.first, ...(options ?? [])];
  }

  static void setPreAndPostChecks({
    InternetConnectionCondition precheck,
    InternetConnectionCondition postcheck,
  }) {
    instance._precheck = precheck;
    instance._postcheck = postcheck;
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
      LogService.info(
        "No internet available: $_",
      );

      isConnected = false;
    } on TimeoutException catch (_) {
      LogService.info(
        "Internet check timeout after $timeout seconds",
      );
      isConnected = false;
    } finally {
      socket?.destroy();
    }
    return isConnected;
  }

  Future<bool> _checkForActiveConnection() async {
    if (_precheck != null && !await _precheck()) {
      LogService.info(
        "Internet connection test: Pre-check condition failed",
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
      LogService.info(
        "Internet connection test: Post-check condition failed",
      );
      isConnected = false;
    }
    return isConnected;
  }
}
