import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/orders/data/datasources/remote/order_remote_data_source.dart';
import 'package:wisatabumnag/shared/orders/data/models/midtrans_payment_response.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_payload.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/payment_payload.model.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/midtrans_payment.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/repositories/order_repository.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._remoteDataSource);
  final OrderRemoteDataSource _remoteDataSource;
  @override
  Future<Either<Failure, Order>> createOrder(OrderForm form) =>
      _remoteDataSource.createOrder(OrderPayload.fromDomain(form)).then(
            (value) => value.map(
              (r) => r.toDomain(),
            ),
          );

  @override
  Future<Either<Failure, Order>> paymentOnSite(PaymentForm form) =>
      _remoteDataSource.payOnsite(PaymentPayload.fromDomain(form)).then(
            (value) => value.map(
              (r) => r.toDomain(),
            ),
          );

  @override
  Future<Either<Failure, MidtransPayment>> paymentOnline(PaymentForm form) =>
      _remoteDataSource.payOnline(PaymentPayload.fromDomain(form)).then(
            (value) => value.map(
              (r) => r.toDomain(),
            ),
          );
}
