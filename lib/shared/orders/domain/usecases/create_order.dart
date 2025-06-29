import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/repositories/order_repository.dart';

@lazySingleton
class CreateOrder extends UseCase<UserOrder, CreateOrderParams> {
  const CreateOrder(this._repository);
  final OrderRepository _repository;
  @override
  Future<Either<Failure, UserOrder>> call(CreateOrderParams params) =>
      _repository.createOrder(params.form);
}

@immutable
class CreateOrderParams extends Equatable {
  const CreateOrderParams(this.form);
  final OrderForm form;
  @override
  List<Object?> get props => [form];
}
