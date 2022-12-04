import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/features/settings/data/datasources/remote/client/profile_api_client.dart';
import 'package:wisatabumnag/features/settings/data/models/update_password_payload.model.dart';
import 'package:wisatabumnag/features/settings/data/models/update_profile_payload.model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserDataResponse>> updateProfile(
    UpdateProfilePayload payload,
  );
  Future<Either<Failure, Unit>> updatePassword(UpdatePasswordPayload payload);
  Future<Either<Failure, UserDataResponse>> updateAvatar(File avatar);
  Future<Either<Failure, UserDataResponse>> getProfile();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._provider, this._client);
  final MiddlewareProvider _provider;
  final ProfileApiClient _client;
  @override
  Future<Either<Failure, UserDataResponse>> updateAvatar(File avatar) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _client.updateAvatar(avatar).then(
              (value) => value.data!,
            ),
      );

  @override
  Future<Either<Failure, Unit>> updatePassword(UpdatePasswordPayload payload) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _client
            .updatePassword(
              oldPassword: payload.oldPassword,
              password: payload.password,
              passwordConfirmation: payload.passwordConfirmation,
            )
            .then(
              (value) => unit,
            ),
      );

  @override
  Future<Either<Failure, UserDataResponse>> updateProfile(
    UpdateProfilePayload payload,
  ) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _client
            .updateProfile(
              name: payload.name,
              nik: payload.nik,
              phoneNumber: payload.phoneNumber,
            )
            .then(
              (value) => value.data!,
            ),
      );

  @override
  Future<Either<Failure, UserDataResponse>> getProfile() => safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _client.getProfile().then(
              (value) => value.data!,
            ),
      );
}
