import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wisatabumnag/core/networks/interceptors/api_key_interceptor.dart';
import 'package:wisatabumnag/core/networks/interceptors/refresh_token_interceptor.dart';
import 'package:wisatabumnag/core/networks/interceptors/signature_interceptor.dart';
import 'package:wisatabumnag/core/networks/interceptors/token_interceptor.dart';
import 'package:wisatabumnag/core/networks/interceptors/url_interceptor.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/injector.dart';

@LazySingleton(as: Dio)
@Named(InjectionConstants.publicDio)
class PublicDio with DioMixin implements Dio {
  PublicDio(
    this._urlInterceptor,
    this._apiKeyInterceptor,
    this._signatureInterceptor,
    this._alice,
  ) {
    final newOptions = BaseOptions(
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    );

    options = newOptions;
    httpClientAdapter = HttpClientAdapter();
    interceptors.addAll([
      _urlInterceptor,
      _apiKeyInterceptor,
      _signatureInterceptor,
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
      if (kDebugMode || kProfileMode) _alice,
    ]);
  }

  final ApiKeyInterceptor _apiKeyInterceptor;
  final UrlInterceptor _urlInterceptor;
  final SignatureInterceptor _signatureInterceptor;
  final AliceDioAdapter _alice;
}

@LazySingleton(as: Dio)
@Named(InjectionConstants.privateDio)
class PrivateDio with DioMixin implements Dio {
  PrivateDio(
    this._urlInterceptor,
    this._apiKeyInterceptor,
    this._tokenInterceptor,
    this._signatureInterceptor,
    this._alice,
    this._aliceDioAdapter,
  ) {
    final newOptions = BaseOptions(
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    );

    options = newOptions;
    httpClientAdapter = HttpClientAdapter();
    interceptors.addAll([
      _urlInterceptor,
      _apiKeyInterceptor,
      _tokenInterceptor,
      RefreshTokenInterceptor(
        getIt<LocalStorage>(),
        _alice,
      ),
      _signatureInterceptor,
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
      if (kDebugMode || kProfileMode) _aliceDioAdapter,
    ]);
  }

  final ApiKeyInterceptor _apiKeyInterceptor;
  final UrlInterceptor _urlInterceptor;
  final TokenInterceptor _tokenInterceptor;
  final SignatureInterceptor _signatureInterceptor;
  final Alice _alice;
  final AliceDioAdapter _aliceDioAdapter;
}
