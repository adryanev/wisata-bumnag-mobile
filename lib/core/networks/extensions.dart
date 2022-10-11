import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/middlewares/network_middleware.dart';
import 'package:wisatabumnag/core/utils/utils.dart';

Future<Either<Failure, T>> safeRemoteCall<T>({
  List<NetworkMiddleware>? middlewares,
  required Future<T> Function() retrofitCall,
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
  if (exception is DioError) {
    if (exception.type == DioErrorType.response)
      final response = exception.response;
  }

  return const Failure.unexpectedFailure(message: 'message');
}
