import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';

@lazySingleton
class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor(this._preference);
  final LocalStorage _preference;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final apiKey = await _preference.getApiKey();

    final newOption = options.copyWith(
      headers: <String, dynamic>{
        ...options.headers,
        'X-API-KEY': apiKey,
      },
    );

    return handler.next(newOption);
  }
}
