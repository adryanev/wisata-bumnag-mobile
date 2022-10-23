import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';

class SignatureInterceptor extends Interceptor {
  SignatureInterceptor(this.accessTime, this._preference);
  final int accessTime;
  final LocalStorage _preference;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final apiKey = await _preference.getApiKey();
    final salt = await _preference.getSalt();

    final payload = '$salt$accessTime$apiKey';
    final signature = sha256.convert(utf8.encode(payload)).toString();

    final newOption = options.copyWith(
      headers: {
        ...options.headers,
        'X-REQUEST-SIGNATURE': signature,
      },
    );

    return handler.next(newOption);
  }
}
