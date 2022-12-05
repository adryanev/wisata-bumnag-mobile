import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_pasword_form.entity.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_profile_form.entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Unit>> updateProfile(UpdateProfileForm form);
  Future<Either<Failure, Unit>> updatePassword(UpdatePasswordForm form);
  Future<Either<Failure, Unit>> updateAvatar(File avatar);
  Future<Either<Failure, User>> getUserData();
}
