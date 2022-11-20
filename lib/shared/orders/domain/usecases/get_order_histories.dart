import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/repositories/order_repository.dart';

@lazySingleton
class GetOrderHistories
    extends UseCase<Paginable<Order>, GetOrderHistoriesParams> {
  const GetOrderHistories(this._repository);

  final OrderRepository _repository;
  @override
  Future<Either<Failure, Paginable<Order>>> call(
    GetOrderHistoriesParams params,
  ) =>
      _repository.orderHistories(page: params.page);
}

@immutable
class GetOrderHistoriesParams extends Equatable {
  const GetOrderHistoriesParams({this.page = 1});

  final int page;
  @override
  List<Object?> get props => [page];
}
