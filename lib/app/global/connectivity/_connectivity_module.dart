part of 'connectivity_module.dart';

class ConnectivityModule extends GetxService {
  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityResult> get stream =>
      _connectivity.onConnectivityChanged.asBroadcastStream();

  Future<ConnectivityResult> get activeConnectivity async {
    return await _connectivity.checkConnectivity();
  }
}
