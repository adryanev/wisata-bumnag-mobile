import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/event/data/models/event_detail_response.model.dart';
import 'package:wisatabumnag/features/event/data/models/event_response.model.dart';
part 'event_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class EventApiClient {
  @factoryMethod
  factory EventApiClient(@Named(InjectionConstants.publicDio) Dio dio) =
      _EventApiClient;

  @GET('v1/events')
  Future<BasePaginationResponse<List<EventResponse>>> getEvent({
    @Query('page') required int page,
  });

  @GET('v1/events/{id}')
  Future<BaseResponse<EventDetailResponse>> getEventDetail(
    @Path('id') String eventId,
  );
}
