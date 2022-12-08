import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/user_local_model.model.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/settings/data/datasources/local/profile_local_data_source.dart';
import 'package:wisatabumnag/features/settings/data/datasources/remote/profile_remote_data_source.dart';
import 'package:wisatabumnag/features/settings/data/models/update_password_payload.model.dart';
import 'package:wisatabumnag/features/settings/data/models/update_profile_payload.model.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_pasword_form.entity.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_profile_form.entity.dart';

import 'package:wisatabumnag/features/settings/domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  @override
  Future<Either<Failure, User>> getUserData() => _remoteDataSource
      .getProfile()
      .then((value) => value.map((r) => r.toDomain()));

  @override
  Future<Either<Failure, Unit>> updateAvatar(File avatar) =>
      _remoteDataSource.updateAvatar(avatar).then(
            (value) => value
                .map(
                  (r) => _localDataSource.updateProfile(
                    UserLocalModel.fromRemoteModel(r),
                  ),
                )
                .map((r) => unit),
          );

  @override
  Future<Either<Failure, Unit>> updatePassword(UpdatePasswordForm form) =>
      _remoteDataSource.updatePassword(UpdatePasswordPayload.fromDomain(form));

  @override
  Future<Either<Failure, Unit>> updateProfile(UpdateProfileForm form) =>
      _remoteDataSource
          .updateProfile(UpdateProfilePayload.fromDomain(form))
          .then(
            (value) => value
                .map(
                  (r) => _localDataSource.updateProfile(
                    UserLocalModel.fromRemoteModel(r),
                  ),
                )
                .map(
                  (r) => unit,
                ),
          );
}
