import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/settings/domain/repositories/profile_repository.dart';

@lazySingleton
class GetProfile extends UseCase<User, NoParams> {
  const GetProfile(this._repository);
  final ProfileRepository _repository;
  @override
  Future<Either<Failure, User>> call(NoParams params) =>
      _repository.getUserData();
}
