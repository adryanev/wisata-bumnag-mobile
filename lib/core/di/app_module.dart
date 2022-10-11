import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@module
abstract class AppModule {
  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @lazySingleton
  @preResolve
  Future<Connectivity> get connectivityChecker async => Connectivity();

  @lazySingleton
  @preResolve
  Future<InternetConnectionChecker> get connectionChecker async =>
      InternetConnectionChecker.createInstance();
}
