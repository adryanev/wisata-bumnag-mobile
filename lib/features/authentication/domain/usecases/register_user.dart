import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/register/register_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/repositories/authentication_repository.dart';

@injectable
class RegisterUser extends UseCase<Unit, RegisterUserParams> {
  const RegisterUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RegisterUserParams params) {
    return _repository.registerUser(params.registerForm);
  }
}

class RegisterUserParams extends Equatable {
  const RegisterUserParams({required this.registerForm});

  final RegisterForm registerForm;

  @override
  List<Object?> get props => [registerForm];
}
