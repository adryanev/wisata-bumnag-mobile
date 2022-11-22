import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/review/domain/repositories/review_repository.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

@lazySingleton
class GetReviewHistory
    extends UseCase<Paginable<OrderDetail>, GetReviewHistoryParams> {
  const GetReviewHistory(this._repository);

  final ReviewRepository _repository;

  @override
  Future<Either<Failure, Paginable<OrderDetail>>> call(
    GetReviewHistoryParams params,
  ) =>
      _repository.getReviewHistory(page: params.page);
}

class GetReviewHistoryParams extends Equatable {
  const GetReviewHistoryParams({
    this.page = 1,
  });

  final int page;
  @override
  List<Object?> get props => [page];
}
