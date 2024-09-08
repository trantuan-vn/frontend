import 'package:connectivity_plus/connectivity_plus.dart';

// Define the NetworkInfo interface
abstract class INetworkInfo {
  Future<bool> isConnected();
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfo implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  @override
  Future<bool> isConnected() async {
    try {
      var result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      // Handle exceptions if necessary
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }
}
