import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/settings/domain/repositories/profile_repository.dart';

@lazySingleton
class UpdateAvatar extends UseCase<Unit, UpdateAvatarParams> {
  const UpdateAvatar(this._repository);
  final ProfileRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(UpdateAvatarParams params) =>
      _repository.updateAvatar(params.avatar);
}

class UpdateAvatarParams extends Equatable {
  const UpdateAvatarParams(this.avatar);
  final File avatar;
  @override
  List<Object?> get props => [avatar];
}
