import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/services/remote_config/remote_config.entity.dart';

abstract class SplashRepository {
  Future<Either<Failure, RemoteConfig<String, String>>> fetchApiKey();
  Future<Either<Failure, Unit>> saveApiKey(RemoteConfig<String, String> config);

  Future<Either<Failure, RemoteConfig<String, String>>> fetchApiUrl();
  Future<Either<Failure, Unit>> saveApiUrl(RemoteConfig<String, String> config);

  Future<Either<Failure, RemoteConfig<String, String>>> fetchSalt();
  Future<Either<Failure, Unit>> saveSalt(RemoteConfig<String, String> config);

  Future<Either<Failure, RemoteConfig<String, String>>> fetchMapApiKey();
  Future<Either<Failure, Unit>> saveMapApiKey(
    RemoteConfig<String, String> config,
  );
}
