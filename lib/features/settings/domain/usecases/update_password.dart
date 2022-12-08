import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_pasword_form.entity.dart';
import 'package:wisatabumnag/features/settings/domain/repositories/profile_repository.dart';

@lazySingleton
class UpdatePassword extends UseCase<Unit, UpdatePasswordParams> {
  const UpdatePassword(this._repository);

  final ProfileRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(UpdatePasswordParams params) =>
      _repository.updatePassword(params.form);
}

class UpdatePasswordParams extends Equatable {
  const UpdatePasswordParams(this.form);

  final UpdatePasswordForm form;
  @override
  List<Object?> get props => [form];
}
