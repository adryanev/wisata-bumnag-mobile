import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(
    this._localStorage,
    this._dio,
  );

  final LocalStorage _localStorage;
  final Dio _dio;

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      _dio.interceptors.remove(this);
      final url = await _localStorage.getBaseUrl();

      try {
        final newToken =
            await _dio.post<BaseResponse<AuthorizationDataResponse>>(
          '${url}v1/auth/refresh',
        );
        if (newToken.data?.data?.accessToken != null) {
          final token = newToken.data!.data!.accessToken!;
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
