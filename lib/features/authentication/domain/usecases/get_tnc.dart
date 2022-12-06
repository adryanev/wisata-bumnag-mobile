import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/authentication/domain/repositories/authentication_repository.dart';

@injectable
class GetTnc extends UseCase<String, NoParams> {
  const GetTnc(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return _repository.getTnc();
  }
}
