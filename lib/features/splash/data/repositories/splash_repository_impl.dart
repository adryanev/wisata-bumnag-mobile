import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/splash/data/datasources/local/splash_local_data_source.dart';
import 'package:wisatabumnag/features/splash/data/datasources/remote/splash_remote_data_source.dart';
import 'package:wisatabumnag/features/splash/domain/repositories/splash_repository.dart';
import 'package:wisatabumnag/services/remote_config/remote_config.entity.dart';
import 'package:wisatabumnag/services/remote_config/remote_config_key.dart';

@LazySingleton(as: SplashRepository)
class SplashRepositoryImpl implements SplashRepository {
  const SplashRepositoryImpl(this._localSource, this._remoteSource);
  final SplashLocalDataSource _localSource;
  final SplashRemoteDataSource _remoteSource;
  @override
  Future<Either<Failure, RemoteConfig<String, String>>> fetchApiKey() =>
      _remoteSource.getApiKey().then(
            (value) => value.map(
              (r) => RemoteConfig(
                key: RemoteConfigKey.apiKey,
                value: r,
              ),
            ),
          );

  @override
  Future<Either<Failure, RemoteConfig<String, String>>> fetchApiUrl() =>
      _remoteSource.getApiUrl().then(
            (value) => value.map(
              (r) => RemoteConfig(
                key: RemoteConfigKey.apiUrl,
                value: r,
              ),
            ),
          );

  @override
  Future<Either<Failure, RemoteConfig<String, String>>> fetchSalt() =>
      _remoteSource.getSalt().then(
            (value) => value.map(
              (r) => RemoteConfig(
                key: RemoteConfigKey.salt,
                value: r,
              ),
            ),
          );

  @override
  Future<Either<Failure, Unit>> saveApiKey(
    RemoteConfig<String, String> config,
  ) =>
      _localSource.saveApiKey(config.value);

  @override
  Future<Either<Failure, Unit>> saveApiUrl(
    RemoteConfig<String, String> config,
  ) =>
      _localSource.saveApiUrl(config.value);

  @override
  Future<Either<Failure, Unit>> saveSalt(RemoteConfig<String, String> config) =>
      _localSource.saveSalt(config.value);

  @override
  Future<Either<Failure, RemoteConfig<String, String>>> fetchMapApiKey() =>
      _remoteSource.getMapApiKey().then(
            (value) => value.map(
              (r) => RemoteConfig(
                key: RemoteConfigKey.mapApiKey,
                value: r,
              ),
            ),
          );

  @override
  Future<Either<Failure, Unit>> saveMapApiKey(
    RemoteConfig<String, String> config,
  ) =>
      _localSource.saveMapApiKey(config.value);

  @override
  Future<Either<Failure, RemoteConfig<String, String>>> fetchTncUrl() =>
      _remoteSource.getTermAndConditionsUrl().then(
            (value) => value.map(
              (r) => RemoteConfig(
                key: RemoteConfigKey.tncUrl,
                value: r,
              ),
            ),
          );

  @override
  Future<Either<Failure, Unit>> saveTncUrl(
    RemoteConfig<String, String> config,
  ) =>
      _localSource.saveTncUrl(config.value);
}
