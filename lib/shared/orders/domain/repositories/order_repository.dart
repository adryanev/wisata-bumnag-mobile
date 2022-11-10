import 'package:dartz/dartz.dart' hide Order;
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/midtrans_payment.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(OrderForm form);
  Future<Either<Failure, Order>> paymentOnSite(PaymentForm form);
  Future<Either<Failure, MidtransPayment>> paymentOnline(PaymentForm form);
}
