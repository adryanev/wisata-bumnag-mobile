import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';

@lazySingleton
class SignatureInterceptor extends Interceptor {
  SignatureInterceptor(this._preference);
  final LocalStorage _preference;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessTime = DateTime.now().millisecondsSinceEpoch / 1000;
    final apiKey = await _preference.getApiKey();
    final salt = await _preference.getSalt();

    final payload = '$salt$accessTime$apiKey';
    final signature = sha256.convert(utf8.encode(payload)).toString();

    final newOption = options.copyWith(
      headers: {
        ...options.headers,
        'X-REQUEST-SIGNATURE': signature,
        'X-ACCESS-TIME': accessTime,
      },
    );

    return handler.next(newOption);
  }
}
