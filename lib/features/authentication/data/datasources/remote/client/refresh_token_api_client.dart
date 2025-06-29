import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';

part 'refresh_token_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class RefreshTokenApiClient {
  @factoryMethod
  factory RefreshTokenApiClient(@Named(InjectionConstants.privateDio) Dio dio) =
      _RefreshTokenApiClient;

  @POST('v1/auth/refresh')
  Future<BaseResponse<AuthorizationDataResponse>> refresh();

  @POST('v1/auth/fcm')
  @FormUrlEncoded()
  Future<BaseResponse<String>> updateFcm(@Field('fcm_token') String fcmToken);
}
