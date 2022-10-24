import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/core/utils/utils.dart';

abstract class SplashLocalDataSource {
  Future<Either<Failure, Unit>> saveApiKey(String apiKey);
  Future<Either<Failure, Unit>> saveApiUrl(String apiUrl);
  Future<Either<Failure, Unit>> saveSalt(String salt);
}

@LazySingleton(as: SplashLocalDataSource)
class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  const SplashLocalDataSourceImpl(this._storage);
  final LocalStorage _storage;
  @override
  Future<Either<Failure, Unit>> saveApiKey(String apiKey) async => safeCall(
        tryCallback: () async {
          await _storage.setApiKey(apiKey);
          return right(unit);
        },
        exceptionCallBack: () {
          return left(
            const Failure.localFailure(message: 'cannot set api key'),
          );
        },
      );

  @override
  Future<Either<Failure, Unit>> saveApiUrl(String apiUrl) async => safeCall(
        tryCallback: () async {
          await _storage.setBaseUrl(apiUrl);
          return right(unit);
        },
        exceptionCallBack: () {
          return left(
            const Failure.localFailure(message: 'cannot set api url'),
          );
        },
      );

  @override
  Future<Either<Failure, Unit>> saveSalt(String salt) async => safeCall(
        tryCallback: () async {
          await _storage.setSalt(salt);
          return right(unit);
        },
        exceptionCallBack: () {
          return left(
            const Failure.localFailure(message: 'cannot set api key'),
          );
        },
      );
}
