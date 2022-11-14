import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/repositories/order_repository.dart';

@lazySingleton
class CreatePaymentOnsite extends UseCase<Order, CreatePaymentOnsiteParams> {
  const CreatePaymentOnsite(this._repository);
  final OrderRepository _repository;
  @override
  Future<Either<Failure, Order>> call(CreatePaymentOnsiteParams params) =>
      _repository.paymentOnSite(params.form);
}

@immutable
class CreatePaymentOnsiteParams extends Equatable {
  const CreatePaymentOnsiteParams(this.form);
  final PaymentForm form;
  @override
  List<Object?> get props => [form];
}
