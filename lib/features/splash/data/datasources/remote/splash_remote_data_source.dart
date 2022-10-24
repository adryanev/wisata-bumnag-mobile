import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/services/remote_config/remote_config_service.dart';

abstract class SplashRemoteDataSource {
  Future<Either<Failure, String>> getApiKey();
  Future<Either<Failure, String>> getApiUrl();
  Future<Either<Failure, String>> getSalt();
}

@LazySingleton(as: SplashRemoteDataSource)
class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  const SplashRemoteDataSourceImpl(this._service);
  final RemoteConfigService _service;
  @override
  Future<Either<Failure, String>> getApiKey() async {
    final result = await _service.getApiKey();
    if (result != null) {
      return right(result);
    }
    return left(
      const Failure.remoteConfigFailure(message: 'Cannot get api key'),
    );
  }

  @override
  Future<Either<Failure, String>> getApiUrl() async {
    final result = await _service.getBaseUrl();
    if (result != null) {
      return right(result);
    }
    return left(
      const Failure.remoteConfigFailure(message: 'Cannot get api url'),
    );
  }

  @override
  Future<Either<Failure, String>> getSalt() async {
    final result = await _service.getSalt();
    if (result != null) {
      return right(result);
    }
    return left(
      const Failure.remoteConfigFailure(message: 'Cannot get secure salt'),
    );
  }
}
