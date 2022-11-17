import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/souvenir/data/models/destination_souvenir_response.model.dart';
import 'package:wisatabumnag/features/souvenir/data/models/souvenir_response.model.dart';

part 'souvenir_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class SouvenirApiClient {
  @factoryMethod
  factory SouvenirApiClient(@Named(InjectionConstants.publicDio) Dio dio) =
      _SouvenirApiClient;

  @GET('v1/souvenirs/destination/{id}')
  Future<BaseResponse<List<SouvenirResponse>>> getSouvenirByDestination(
    @Path('id') String id,
  );

  @GET('v1/souvenirs')
  Future<BasePaginationResponse<List<DestinationSouvenirResponse>>>
      getSouvenirLists({
    @Query('page') int page,
  });
}
