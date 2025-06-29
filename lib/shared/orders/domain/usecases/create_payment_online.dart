import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/midtrans_payment.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/repositories/order_repository.dart';

@lazySingleton
class CreatePaymentOnline
    extends UseCase<MidtransPayment, CreatePaymentOnlineParams> {
  const CreatePaymentOnline(this._repository);
  final OrderRepository _repository;
  @override
  Future<Either<Failure, MidtransPayment>> call(
    CreatePaymentOnlineParams params,
  ) =>
      _repository.paymentOnline(params.form);
}

@immutable
class CreatePaymentOnlineParams extends Equatable {
  const CreatePaymentOnlineParams(this.form);
  final PaymentForm form;
  @override
  List<Object?> get props => [form];
}
