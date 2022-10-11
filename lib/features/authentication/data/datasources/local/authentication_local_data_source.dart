import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/core/utils/utils.dart';
import 'package:wisatabumnag/features/authentication/data/models/user_local_model.model.dart';

abstract class AuthenticationLocalDataSource {
  Future<Either<Failure, UserLocalModel?>> getLoggedInUser();
  Future<Either<Failure, Unit>> logoutUser();
}

@LazySingleton(as: AuthenticationLocalDataSource)
class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  const AuthenticationLocalDataSourceImpl(this._storage);
  final LocalStorage _storage;
  @override
  Future<Either<Failure, UserLocalModel?>> getLoggedInUser() async {
    return safeCall(
      tryCallback: () async {
        final data = await _storage.getLoggedInUser();
        return right(data);
      },
      exceptionCallBack: () {
        return left(
          const Failure.localFailure(message: 'Cannot get user login data'),
        );
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> logoutUser() async {
    return safeCall(
      tryCallback: () async {
        await _storage.logoutUser();
        return right(unit);
      },
      exceptionCallBack: () {
        return left(const Failure.localFailure(message: 'Cannot logout user'));
      },
    );
  }
}
