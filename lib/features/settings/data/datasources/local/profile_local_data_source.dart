import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/core/utils/utils.dart';
import 'package:wisatabumnag/features/authentication/data/models/user_local_model.model.dart';

abstract class ProfileLocalDataSource {
  Future<Either<Failure, UserLocalModel>> getProfile();
  Future<Either<Failure, Unit>> updateProfile(UserLocalModel user);
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(this._localStorage);
  final LocalStorage _localStorage;
  @override
  Future<Either<Failure, UserLocalModel>> getProfile() => safeCall(
        tryCallback: () =>
            _localStorage.getLoggedInUser().then((value) => right(value!)),
        exceptionCallBack: () async => left(
          const Failure.localFailure(
            message: 'cannot get user',
          ),
        ),
      );

  @override
  Future<Either<Failure, Unit>> updateProfile(UserLocalModel model) => safeCall(
        tryCallback: () =>
            _localStorage.setLoggedIn(model).then((value) => right(unit)),
        exceptionCallBack: () async => left(
          const Failure.localFailure(
            message: 'cannot save user',
          ),
        ),
      );
}
