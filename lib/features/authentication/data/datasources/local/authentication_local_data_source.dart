import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/authentication/data/models/user_local_model.model.dart';

abstract class AuthenticationLocalDataSource {
  Future<Either<Failure, UserLocalModel?>> getLoggedInUser();
  Future<Either<Failure, Unit>> logoutUser();
}
