import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/features/home/data/datasources/remote/client/home_front_api_client.dart';
import 'package:wisatabumnag/features/home/data/models/ad_banner_response.model.dart';
import 'package:wisatabumnag/features/home/data/models/explore/explore_response.model.dart';
import 'package:wisatabumnag/features/home/data/models/recommendation_response.model.dart';

abstract class HomeFrontRemoteDataSource {
  Future<Either<Failure, List<AdBannerResponse>>> fetchAdBanners();
  Future<Either<Failure, List<RecommendationResponse>>> fetchRecommendations();
  Future<Either<Failure, BasePaginationResponse<List<ExploreResponse>>>>
      fetchExplore({
    required int page,
  });
}

@LazySingleton(as: HomeFrontRemoteDataSource)
class HomeFrontRemoteDataSourceImpl implements HomeFrontRemoteDataSource {
  const HomeFrontRemoteDataSourceImpl(this._client, this._middlewareProvider);
  final HomeFrontApiClient _client;
  final MiddlewareProvider _middlewareProvider;
  @override
  Future<Either<Failure, List<AdBannerResponse>>> fetchAdBanners() =>
      safeRemoteCall(
        middlewares: _middlewareProvider.getAll(),
        retrofitCall: () =>
            _client.fetchAdBanners().then((value) => value.data!),
      );

  @override
  Future<Either<Failure, List<RecommendationResponse>>>
      fetchRecommendations() => safeRemoteCall(
            middlewares: _middlewareProvider.getAll(),
            retrofitCall: () =>
                _client.fetchRecommendations().then((value) => value.data!),
          );

  @override
  Future<Either<Failure, BasePaginationResponse<List<ExploreResponse>>>>
      fetchExplore({
    required int page,
  }) =>
          safeRemoteCall(
            middlewares: _middlewareProvider.getAll(),
            retrofitCall: () => _client.fetchExplore(page: page),
          );
}
