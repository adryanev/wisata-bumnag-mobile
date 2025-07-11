import 'dart:convert';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(
    this._localStorage,
    this._alice,
  ) : _dio = Dio();

  final LocalStorage _localStorage;
  final Dio _dio;
  final Alice _alice;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      final url = await _localStorage.getBaseUrl();

      try {
        _dio.interceptors.clear();
        _dio.interceptors.add(AliceDioAdapter());
        final apiKey = await _localStorage.getApiKey();
        final token = await _localStorage.getAccessToken();
        final accessTime = DateTime.now().millisecondsSinceEpoch / 1000;
        final salt = await _localStorage.getSalt();

        final payload = '$salt$accessTime$apiKey';
        final signature = sha256.convert(utf8.encode(payload)).toString();

        final newToken = await _dio.post<Map<String, dynamic>>(
          '${url}v1/auth/refresh',
          options: Options(
            headers: {
              ..._dio.options.headers,
              'Accept': 'application/json',
              'X-API-KEY': apiKey,
              'Authorization': 'Bearer $token',
              'X-REQUEST-SIGNATURE': signature,
              'X-ACCESS-TIME': accessTime,
            },
            contentType: 'application/json',
          ),
        );
        final authorization = BaseResponse<AuthorizationDataResponse>.fromJson(
          newToken.data!,
          (json) => AuthorizationDataResponse.fromJson(
            json! as Map<String, dynamic>,
          ),
        );
        if (authorization.data?.accessToken != null) {
          final token = authorization.data!.accessToken!;
          final headers = err.requestOptions.headers;
          await _localStorage.setAccessToken(token);
          headers['Authorization'] = 'Bearer $token';
          final newOption = err.requestOptions.copyWith(headers: headers);
          final result = await _dio.request<dynamic>(
            err.requestOptions.path,
            queryParameters: err.requestOptions.queryParameters,
            data: err.requestOptions.data,
            options:
                Options(method: newOption.method, headers: newOption.headers),
          );
          return handler.resolve(result);
        }
      } catch (e) {
        await _localStorage.logoutUser();

        return handler.reject(err);
      }
    }
    return handler.next(err);
  }
}
