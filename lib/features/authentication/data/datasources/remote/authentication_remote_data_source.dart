import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/utils.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_payload.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/register/register_payload.model.dart';
import 'package:wisatabumnag/injector.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Either<Failure, BaseResponse<String>>> registerUser(
    RegisterPayload payload,
  );
  Future<Either<Failure, BaseResponse<LoginResponse>>> loginUser(
    LoginPayload payload,
  );
}

@development
@testing
@LazySingleton(as: AuthenticationRemoteDataSource)
class FakeAuthenticationRemoteDataSource
    implements AuthenticationRemoteDataSource {
  @override
  Future<Either<Failure, BaseResponse<LoginResponse>>> loginUser(
    LoginPayload payload,
  ) async {
    return safeCall(
      tryCallback: () async {
        String? data;
        if (payload.emailAddress == 'rywukafe@getnada.com') {
          data = await rootBundle
              .loadString('assets/jsons/fixture/login/login_success.json');
          final response = BaseResponse<LoginResponse>.fromJson(
            jsonDecode(data) as Map<String, dynamic>,
            (json) => LoginResponse.fromJson(
              json! as Map<String, dynamic>,
            ),
          );
          return right(response);
        }
        return left(const Failure.serverFailure(message: ''));
      },
      exceptionCallBack: () {
        return left(const Failure.serverFailure(message: ''));
      },
    );
  }

  @override
  Future<Either<Failure, BaseResponse<String>>> registerUser(
    RegisterPayload payload,
  ) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}

@staging
@production
@LazySingleton(as: AuthenticationRemoteDataSource)
class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  @override
  Future<Either<Failure, BaseResponse<LoginResponse>>> loginUser(
    LoginPayload payload,
  ) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BaseResponse<String>>> registerUser(
    RegisterPayload payload,
  ) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
