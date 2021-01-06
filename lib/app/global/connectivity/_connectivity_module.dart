part of 'connectivity_module.dart';

class ConnectivityModule extends GetxService {
  ConnectivityModule._();
  static ConnectivityModule _instance = ConnectivityModule._();
  static ConnectivityModule get instance => _instance;

  /// gives new instance of [ConnectivityModule] class
  factory ConnectivityModule.newInstance() => ConnectivityModule._();

  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityResult> get stream =>
      _connectivity.onConnectivityChanged.asBroadcastStream();

  Future<ConnectivityResult> get activeConnectivity async {
    return await _connectivity.checkConnectivity();
  }
}
