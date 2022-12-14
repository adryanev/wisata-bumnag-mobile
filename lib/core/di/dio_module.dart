import 'package:alice/alice.dart';
import 'package:dio/adapter.dart';
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
      connectTimeout: 120000,
      sendTimeout: 120000,
      receiveTimeout: 120001,
    );

    options = newOptions;
    interceptors.addAll([
      _urlInterceptor,
      _apiKeyInterceptor,
      _signatureInterceptor,
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
      if (kDebugMode || kProfileMode) _alice.getDioInterceptor(),
    ]);

    httpClientAdapter = DefaultHttpClientAdapter();
  }

  final ApiKeyInterceptor _apiKeyInterceptor;
  final UrlInterceptor _urlInterceptor;
  final SignatureInterceptor _signatureInterceptor;
  final Alice _alice;
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
  ) {
    final newOptions = BaseOptions(
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
      connectTimeout: 120000,
      sendTimeout: 120000,
      receiveTimeout: 120001,
    );

    options = newOptions;
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
      if (kDebugMode || kProfileMode) _alice.getDioInterceptor(),
    ]);

    httpClientAdapter = DefaultHttpClientAdapter();
  }

  final ApiKeyInterceptor _apiKeyInterceptor;
  final UrlInterceptor _urlInterceptor;
  final TokenInterceptor _tokenInterceptor;
  final SignatureInterceptor _signatureInterceptor;
  final Alice _alice;
}
