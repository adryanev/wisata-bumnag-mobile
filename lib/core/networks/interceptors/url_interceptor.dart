import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/errors.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';

@lazySingleton
class UrlInterceptor extends Interceptor {
  UrlInterceptor(this._preference);
  final LocalStorage _preference;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final url = await _preference.getBaseUrl();
    if (url == null) {
      return handler
          .reject(DioError(requestOptions: options, error: NoBaseUrlError()));
    }
    final newOption = options.copyWith(baseUrl: url);
    return handler.next(newOption);
  }
}
