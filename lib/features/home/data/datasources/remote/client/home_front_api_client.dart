import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/home/data/models/ad_banner_response.model.dart';
import 'package:wisatabumnag/features/home/data/models/explore/explore_response.model.dart';
import 'package:wisatabumnag/features/home/data/models/recommendation_response.model.dart';

part 'home_front_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class HomeFrontApiClient {
  @factoryMethod
  factory HomeFrontApiClient(@Named(InjectionConstants.publicDio) Dio dio) =
      _HomeFrontApiClient;

  @GET('v1/recommendations')
  Future<BaseResponse<List<RecommendationResponse>>> fetchRecommendations();

  @GET('v1/banners')
  Future<BaseResponse<List<AdBannerResponse>>> fetchAdBanners();

  @GET('v1/explores')
  Future<BasePaginationResponse<List<ExploreResponse>>> fetchExplore({
    @Query('page') required int page,
  });
}
