import 'package:dartz/dartz.dart' hide Order;
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(OrderForm form);
}
