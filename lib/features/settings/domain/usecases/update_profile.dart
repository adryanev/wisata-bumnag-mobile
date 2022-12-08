import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_profile_form.entity.dart';
import 'package:wisatabumnag/features/settings/domain/repositories/profile_repository.dart';

@lazySingleton
class UpdateProfile extends UseCase<Unit, UpdateProfileParams> {
  const UpdateProfile(this._repository);
  final ProfileRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(UpdateProfileParams params) =>
      _repository.updateProfile(params.form);
}

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams(this.form);
  final UpdateProfileForm form;
  @override
  List<Object?> get props => [form];
}
