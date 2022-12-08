import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/features/review/data/datasources/remote/client/review_api_client.dart';
import 'package:wisatabumnag/features/review/data/models/review_payload.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';

abstract class ReviewRemoteDataSource {
  Future<Either<Failure, BasePaginationResponse<List<OrderDetailResponse>>>>
      getReviewHistory({required int page});
  Future<Either<Failure, BasePaginationResponse<List<OrderDetailResponse>>>>
      getWaitingForReview({required int page});
  Future<Either<Failure, Unit>> addReview(ReviewPayload payload);
}

@LazySingleton(as: ReviewRemoteDataSource)
class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  const ReviewRemoteDataSourceImpl(this._client, this._provider);

  final ReviewApiClient _client;
  final MiddlewareProvider _provider;
  @override
  Future<Either<Failure, Unit>> addReview(ReviewPayload payload) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _client.addReview(
          title: payload.title,
          description: payload.description,
          rating: payload.rating,
          userId: payload.userId,
          orderDetailId: payload.orderDetailId,
          orderableType: payload.orderableType,
          reviewableId: payload.reviewableId,
          media: payload.media,
        ),
      ).then(
        (value) => right(unit),
      );

  @override
  Future<Either<Failure, BasePaginationResponse<List<OrderDetailResponse>>>>
      getReviewHistory({required int page}) => safeRemoteCall(
            middlewares: _provider.getAll(),
            retrofitCall: () => _client.getHistoryReview(
              page: page,
            ),
          );

  @override
  Future<Either<Failure, BasePaginationResponse<List<OrderDetailResponse>>>>
      getWaitingForReview({required int page}) => safeRemoteCall(
            middlewares: _provider.getAll(),
            retrofitCall: () => _client.getWaitingForReview(
              page: page,
            ),
          );
}
