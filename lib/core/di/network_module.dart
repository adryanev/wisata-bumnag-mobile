import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wisatabumnag/core/networks/interceptors/access_time_interceptor.dart';
import 'package:wisatabumnag/core/networks/interceptors/api_key_interceptor.dart';
import 'package:wisatabumnag/core/networks/interceptors/signature_interceptor.dart';
import 'package:wisatabumnag/core/networks/interceptors/url_interceptor.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/injector.dart';

@LazySingleton(as: Dio)
@Named(InjectionConstants.publicDio)
@staging
class PublicDio with DioMixin implements Dio {
  PublicDio(this._urlInterceptor, this._apiKeyInterceptor) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final newOptions = BaseOptions(
      contentType: 'application/json',
      connectTimeout: 120000,
      sendTimeout: 120000,
      receiveTimeout: 120001,
    );

    options = newOptions;
    interceptors.addAll([
      _urlInterceptor,
      AccessTimeInterceptor(now),
      _apiKeyInterceptor,
      SignatureInterceptor(now, getIt<LocalStorage>()),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    ]);

    httpClientAdapter = DefaultHttpClientAdapter();
  }

  final ApiKeyInterceptor _apiKeyInterceptor;
  final UrlInterceptor _urlInterceptor;
}
