import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';

@injectable
class ForgotPassword extends UseCase<Unit, ForgotPasswordParams> {
  const ForgotPassword(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.email});

  final EmailAddress email;

  @override
  List<Object?> get props => [email];
}
