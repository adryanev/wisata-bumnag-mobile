import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_payload.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/register/register_payload.model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Either<Failure, BaseResponse<String>>> registerUser(
    RegisterPayload payload,
  );
  Future<Either<Failure, BaseResponse<LoginResponse>>> loginUser(
    LoginPayload payload,
  );
}
