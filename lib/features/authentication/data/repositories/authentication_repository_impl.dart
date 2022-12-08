import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/authentication/data/datasources/local/authentication_local_data_source.dart';
import 'package:wisatabumnag/features/authentication/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_payload.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/register/register_payload.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/user_local_model.model.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/login/login_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/register/register_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:wisatabumnag/services/device_info/device_info_service.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl(
    this._localSource,
    this._remoteDataSource,
    this._deviceInfoService,
  );
  final AuthenticationLocalDataSource _localSource;
  final AuthenticationRemoteDataSource _remoteDataSource;
  final DeviceInfoService _deviceInfoService;
  @override
  Future<Either<Failure, User?>> getLoggedInUser() => _localSource
      .getLoggedInUser()
      .then((value) => value.map((r) => r?.toDomain()));

  @override
  Future<Either<Failure, User>> loginUser(LoginForm loginForm) async {
    final loginPayload =
        await LoginPayloadFactory(_deviceInfoService, _localSource)
            .createFromLoginForm(loginForm);

    final result = await _remoteDataSource.loginUser(loginPayload);
    if (result.isLeft()) {
      final failure = result.getLeft();
      return left(failure!);
    }
    final response = result.getRight();
    final auth = response!.authorization;
    final user = response.user;
    final localModel = UserLocalModel.fromRemoteModel(user);

    final saveUser = await _localSource.saveLogin(localModel);
    if (saveUser.isLeft()) {
      final failure = saveUser.getLeft();
      return left(failure!);
    }
    final saveToken = await _localSource.saveToken(auth.accessToken!);
    if (saveToken.isLeft()) {
      final failure = saveToken.getLeft();
      return left(failure!);
    }
    return right(localModel.toDomain());
  }

  @override
  Future<Either<Failure, Unit>> logout() => _localSource.logoutUser();

  @override
  Future<Either<Failure, Unit>> registerUser(RegisterForm registerForm) =>
      _remoteDataSource.registerUser(
        RegisterPayload.fromDomain(registerForm),
      );

  @override
  Future<Either<Failure, String>> getTnc() => _localSource.getTnc();

  @override
  Future<Either<Failure, Unit>> forgotPassword(EmailAddress emailAddress) =>
      _remoteDataSource.forgotPassword(emailAddress.getOrCrash());
}
