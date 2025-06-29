import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/midtrans_payment.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, UserOrder>> createOrder(OrderForm form);
  Future<Either<Failure, MidtransPayment>> paymentOnline(PaymentForm form);
  Future<Either<Failure, Paginable<UserOrder>>> orderHistories(
      {required int page});
}
