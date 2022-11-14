import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/login/login_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/register/register_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> loginUser(LoginForm loginForm);
  Future<Either<Failure, Unit>> registerUser(RegisterForm registerForm);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User?>> getLoggedInUser();
}
