import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/repositories/authentication_repository.dart';

@injectable
class GetLoggedInUser extends UseCase<User?, NoParams> {
  const GetLoggedInUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return _repository.getLoggedInUser();
  }
}
