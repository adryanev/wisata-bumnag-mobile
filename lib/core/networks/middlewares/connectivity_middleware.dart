import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/middlewares/network_middleware.dart';

class ConnectivityMiddleware extends NetworkMiddleware {
  ConnectivityMiddleware(this._connectivity, this._internet);
  final Connectivity _connectivity;
  final InternetConnectionChecker _internet;
  @override
  Future<bool> isValid() async {
    final connectivity = await _connectivity.checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.ethernet)) {
      return false;
    }
    final internet = await _internet.hasConnection;
    if (!internet) return false;
    return true;
  }

  @override
  NetworkMiddlewareFailure get failure =>
      const NetworkMiddlewareFailure(message: 'No Internet Connection');
}
