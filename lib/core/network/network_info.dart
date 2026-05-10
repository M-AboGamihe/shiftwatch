import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnection _connectionChecker;

  NetworkInfoImpl({
    required Connectivity connectivity,
    required InternetConnection connectionChecker,
  })  : _connectivity = connectivity,
        _connectionChecker = connectionChecker;

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasSignal = connectivityResult.any((r) => r != ConnectivityResult.none);
    if (!hasSignal) {
      return false;
    }
    return _connectionChecker.hasInternetAccess;
  }
}
