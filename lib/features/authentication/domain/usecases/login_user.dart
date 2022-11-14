import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/login/login_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/repositories/authentication_repository.dart';

@injectable
class LoginUser extends UseCase<User, LoginUserParams> {
  const LoginUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<Either<Failure, User>> call(LoginUserParams params) {
    return _repository.loginUser(params.loginForm);
  }
}

class LoginUserParams extends Equatable {
  const LoginUserParams({required this.loginForm});

  final LoginForm loginForm;

  @override
  List<Object?> get props => [loginForm];
}
