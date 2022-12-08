import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/review/domain/entities/review_form.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, Paginable<OrderDetail>>> getWaitingForReview({
    required int page,
  });
  Future<Either<Failure, Paginable<OrderDetail>>> getReviewHistory({
    required int page,
  });

  Future<Either<Failure, Unit>> addReview(ReviewForm form);
}
