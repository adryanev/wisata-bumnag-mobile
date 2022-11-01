import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_detail_response.model.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_response.model.dart';
part 'destination_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class DestinationApiClient {
  @factoryMethod
  factory DestinationApiClient(@Named(InjectionConstants.publicDio) Dio dio) =
      _DestinationApiClient;

  @GET('v1/destinations')
  Future<BasePaginationResponse<List<DestinationResponse>>> getDestination(
    @Query('category') int categoryId,
    @Query('page') int page,
  );

  @GET('v1/destinations/{id}')
  Future<BaseResponse<DestinationDetailResponse>> getDestinationDetail(
    @Path('id') String destinationId,
  );
}
