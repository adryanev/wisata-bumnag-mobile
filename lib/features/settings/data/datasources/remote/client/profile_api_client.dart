import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';

part 'profile_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(@Named(InjectionConstants.privateDio) Dio dio) =
      _ProfileApiClient;

  @PUT('v1/profiles/update')
  @FormUrlEncoded()
  Future<BaseResponse<UserDataResponse>> updateProfile({
    @Field('name') required String name,
    @Field('nik') required String? nik,
    @Field('phone_number') required String? phoneNumber,
  });

  @POST('v1/profiles/avatar')
  @MultiPart()
  Future<BaseResponse<UserDataResponse>> updateAvatar(
    @Part(name: 'avatar') File avatar,
  );

  @PUT('v1/profiles/password')
  @FormUrlEncoded()
  Future<BaseResponse<String>> updatePassword({
    @Field('old_password') required String oldPassword,
    @Field('password') required String password,
    @Field('password_confirmation') required String passwordConfirmation,
  });

  @GET('v1/profiles')
  Future<BaseResponse<UserDataResponse>> getProfile();
}
