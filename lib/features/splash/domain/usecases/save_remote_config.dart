import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/splash/domain/repositories/splash_repository.dart';
import 'package:wisatabumnag/services/remote_config/remote_config.entity.dart';
import 'package:wisatabumnag/services/remote_config/remote_config_key.dart';

@injectable
class SaveRemoteConfig extends UseCase<Unit, SaveRemoteConfigParams> {
  const SaveRemoteConfig(this._repository);
  final SplashRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(
    SaveRemoteConfigParams params,
  ) async {
    switch (params.config.key) {
      case RemoteConfigKey.apiKey:
        return _repository.saveApiKey(params.config);
      case RemoteConfigKey.apiUrl:
        return _repository.saveApiUrl(params.config);
      case RemoteConfigKey.salt:
        return _repository.saveSalt(params.config);
      case RemoteConfigKey.mapApiKey:
        return _repository.saveMapApiKey(params.config);
    }
    return left(
      const Failure.unexpectedFailure(
        message: 'no remote config key specified',
      ),
    );
  }
}

class SaveRemoteConfigParams extends Equatable {
  const SaveRemoteConfigParams({
    required this.config,
  });
  final RemoteConfig<String, String> config;

  @override
  List<Object?> get props => [config];
}
