import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/notification/data/models/notification_response.model.dart';

part 'notification_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class NotificationApiClient {
  @factoryMethod
  factory NotificationApiClient(@Named(InjectionConstants.privateDio) Dio dio) =
      _NotificationApiClient;

  @GET('v1/notifications')
  Future<BaseResponse<List<NotificationResponse>>> getNotification();

  @GET('v1/notifications/paginate')
  Future<BasePaginationResponse<List<NotificationResponse>>> withPagination({
    required int page,
  });

  @FormUrlEncoded()
  @POST('v1/notifications/read')
  Future<BaseResponse<String>> read(@Field('id') String id);

  @POST('v1/notifications/read-all')
  Future<BaseResponse<String>> readAll();

  @DELETE('v1/notifications/delete')
  Future<BaseResponse<String>> delete();
}
