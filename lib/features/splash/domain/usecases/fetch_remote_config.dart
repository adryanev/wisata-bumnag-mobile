import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/splash/domain/repositories/splash_repository.dart';
import 'package:wisatabumnag/services/remote_config/remote_config.entity.dart';

@injectable
class FetchRemoteConfig
    extends UseCase<RemoteConfig<String, String>, FetchRemoteConfigParams> {
  const FetchRemoteConfig(this._repository);
  final SplashRepository _repository;
  @override
  Future<Either<Failure, RemoteConfig<String, String>>> call(
    FetchRemoteConfigParams params,
  ) async {
    switch (params.remoteConfigType) {
      case RemoteConfigType.apiKey:
        return _repository.fetchApiKey();
      case RemoteConfigType.apiUrl:
        return _repository.fetchApiUrl();
      case RemoteConfigType.salt:
        return _repository.fetchSalt();
      case RemoteConfigType.mapApiKey:
        return _repository.fetchMapApiKey();
    }
  }
}

class FetchRemoteConfigParams extends Equatable {
  const FetchRemoteConfigParams({
    required this.remoteConfigType,
  });
  final RemoteConfigType remoteConfigType;

  @override
  List<Object?> get props => [remoteConfigType];
}

enum RemoteConfigType { apiKey, apiUrl, salt, mapApiKey }
