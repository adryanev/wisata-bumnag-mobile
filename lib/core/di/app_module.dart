import 'package:alice/alice.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  MiddlewareProvider middlewareProvider(
    Connectivity connectivity,
    InternetConnectionChecker internetConnectionChecker,
  ) =>
      MiddlewareProviderBuilder()
          .addMiddleware(
            ConnectivityMiddleware(connectivity, internetConnectionChecker),
          )
          .build();

  @lazySingleton
  FlutterLocalNotificationsPlugin proviceFlutterNotification() =>
      FlutterLocalNotificationsPlugin();

  @lazySingleton
  ImagePicker get picker => ImagePicker();

  @lazySingleton
  ImageCropper get cropper => ImageCropper();

  @lazySingleton
  Alice get alice => Alice();
}
