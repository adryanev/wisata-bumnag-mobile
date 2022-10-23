import 'package:dio/dio.dart';

class AccessTimeInterceptor extends Interceptor {
  AccessTimeInterceptor(this.accessTime);
  final int accessTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final newOption = options.copyWith(
      headers: <String, dynamic>{
        ...options.headers,
        'X-ACCESS-TIME': accessTime,
      },
    );

    return handler.next(newOption);
  }
}
