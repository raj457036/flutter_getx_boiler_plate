import 'package:connectivity/connectivity.dart';

class ConnectivityHandler {
  ConnectivityHandler._();

  static ConnectivityHandler _instance = ConnectivityHandler._();
  static ConnectivityHandler get instance => _instance;
  static ConnectivityHandler get I => _instance;

  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityResult> get stream =>
      _connectivity.onConnectivityChanged.asBroadcastStream();

  Future<ConnectivityResult> get activeConnectivity async {
    return await _connectivity.checkConnectivity();
  }
}
