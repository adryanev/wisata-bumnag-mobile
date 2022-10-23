import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wisatabumnag/core/networks/middlewares/connectivity_middleware.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';

@module
abstract class AppModule {
  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @lazySingleton
  @preResolve
  Future<Connectivity> get connectivityChecker async => Connectivity();

  @lazySingleton
  InternetConnectionChecker get connectionChecker =>
      InternetConnectionChecker.createInstance();

  @lazySingleton
  @preResolve
  MiddlewareProvider middlewareProvider(
    Connectivity connectivity,
    InternetConnectionChecker internetConnectionChecker,
  ) =>
      MiddlewareProviderBuilder()
          .addMiddleware(
            ConnectivityMiddleware(connectivity, internetConnectionChecker),
          )
          .build();
}
