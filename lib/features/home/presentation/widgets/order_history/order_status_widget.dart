import 'package:flutter/material.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({super.key, required this.status});
  final OrderStatus status;
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case OrderStatus.created:
        return Text(
          OrderStatusMapper.toText(status),
        );

      case OrderStatus.paid:
        return Text(OrderStatusMapper.toText(status));

      case OrderStatus.cancelled:
        return Text(OrderStatusMapper.toText(status));

      case OrderStatus.completed:
        return Text(OrderStatusMapper.toText(status));

      case OrderStatus.refunded:
        return Text(OrderStatusMapper.toText(status));
    }
  }
}
