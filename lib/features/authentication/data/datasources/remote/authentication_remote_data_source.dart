import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/features/authentication/data/datasources/remote/client/authentication_api_client.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_payload.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/register/register_payload.model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Either<Failure, Unit>> registerUser(
    RegisterPayload payload,
  );
  Future<Either<Failure, LoginResponse>> loginUser(
    LoginPayload payload,
  );
  Future<Either<Failure, Unit>> forgotPassword(String email);
}

@LazySingleton(as: AuthenticationRemoteDataSource)
class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImpl(
    this._middlewareProvider,
    this._client,
  );
  final AuthenticationApiClient _client;
  final MiddlewareProvider _middlewareProvider;
  @override
  Future<Either<Failure, LoginResponse>> loginUser(
    LoginPayload payload,
  ) =>
      safeRemoteCall(
        middlewares: _middlewareProvider.getAll(),
        retrofitCall: () async =>
            _client.loginUser(payload).then((value) => value.data!),
      );

  @override
  Future<Either<Failure, Unit>> registerUser(
    RegisterPayload payload,
  ) =>
      safeRemoteCall(
        middlewares: _middlewareProvider.getAll(),
        retrofitCall: () async => _client.registerUser(payload).then(
              (value) => unit,
            ),
      );

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) => safeRemoteCall(
        middlewares: _middlewareProvider.getAll(),
        retrofitCall: () => _client.forgotPassword(email).then(
              (value) => unit,
            ),
      );
}
