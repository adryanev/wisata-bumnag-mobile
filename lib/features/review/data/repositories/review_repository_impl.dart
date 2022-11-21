import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/review/data/datasources/remote/review_remote_data_source.dart';
import 'package:wisatabumnag/features/review/data/models/review_payload.model.dart';
import 'package:wisatabumnag/features/review/domain/entities/review_form.entity.dart';
import 'package:wisatabumnag/features/review/domain/repositories/review_repository.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

@LazySingleton(as: ReviewRepository)
class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl(this._dataSource);

  final ReviewRemoteDataSource _dataSource;
  @override
  Future<Either<Failure, Unit>> addReview(ReviewForm form) =>
      _dataSource.addReview(ReviewPayload.fromDomain(form));

  @override
  Future<Either<Failure, Paginable<OrderDetail>>> getReviewHistory({
    required int page,
  }) =>
      _dataSource.getReviewHistory(page: page).then(
            (value) => value.map(
              (r) => Paginable(
                data: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );

  @override
  Future<Either<Failure, Paginable<OrderDetail>>> getWaitingForReview({
    required int page,
  }) =>
      _dataSource.getWaitingForReview(page: page).then(
            (value) => value.map(
              (r) => Paginable(
                data: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );
}
