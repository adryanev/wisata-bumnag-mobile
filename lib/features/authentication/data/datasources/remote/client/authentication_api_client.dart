import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_payload.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/features/authentication/data/models/register/register_payload.model.dart';

part 'authentication_api_client.g.dart';

@RestApi()
@lazySingleton
abstract class AuthenticationApiClient {
  @factoryMethod
  factory AuthenticationApiClient(
    @Named(InjectionConstants.publicDio) Dio dio,
  ) = _AuthenticationApiClient;

  @POST('v1/auth/register')
  Future<BaseResponse<String>> registerUser(@Body() RegisterPayload payload);

  @POST('v1/auth/login')
  Future<BaseResponse<LoginResponse>> loginUser(@Body() LoginPayload payload);

  @POST('v1/auth/forgot-password')
  @FormUrlEncoded()
  Future<BaseResponse<String>> forgotPassword(@Field('email') String email);
}
