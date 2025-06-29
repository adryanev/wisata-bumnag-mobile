import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
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
  Future<Either<Failure, UserOrder>> createOrder(OrderForm form) =>
      _remoteDataSource.createOrder(OrderPayload.fromDomain(form)).then(
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

  @override
  Future<Either<Failure, Paginable<UserOrder>>> orderHistories({
    required int page,
  }) =>
      _remoteDataSource.orderHistories(page: page).then(
            (value) => value.map(
              (r) => Paginable(
                data: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );
}
