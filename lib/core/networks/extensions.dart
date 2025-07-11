// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/middlewares/network_middleware.dart';

Future<Either<Failure, T>> safeRemoteCall<T>({
  required Future<T> Function() retrofitCall,
  List<NetworkMiddleware>? middlewares,
}) async {
  final failure = await _runMiddleware(middlewares ?? []);
  if (failure == null) return _executeRetrofitCall(retrofitCall: retrofitCall);
  return left(failure);
}

Future<Failure?> _runMiddleware(List<NetworkMiddleware> middlewares) async {
  if (middlewares.isEmpty) return null;
  for (final element in middlewares) {
    if (await element.isValid()) {
      continue;
    }
    return element.failure;
  }
  return null;
}

Future<Either<Failure, T>> _executeRetrofitCall<T>({
  required Future<T> Function() retrofitCall,
}) async {
  try {
    final result = await retrofitCall();
    return right(result);
  } catch (e, stackTrace) {
    log(e.toString(), stackTrace: stackTrace);
    return left(_parseException(e));
  }
}

Failure _parseException(Object exception) {
  if (exception is DioException) {
    if (exception.type == DioExceptionType.badResponse) {
      final response = exception.response;
      if (response != null) {
        if (response.statusCode == HttpStatus.unprocessableEntity) {
          final casted = response.data as Map<String, dynamic>;
          final error = casted['errors'] as Map<String, dynamic>;
          return Failure.serverValidationFailure(errors: error);
        }
        return Failure.serverFailure(
          code: response.statusCode!,
          message:
              (response.data?['message'] as String?) ?? response.statusMessage!,
        );
      }
    }
  }

  return Failure.unexpectedFailure(message: '$exception');
}
