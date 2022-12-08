import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({super.key, required this.status});
  final OrderStatus status;
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case OrderStatus.created:
        return DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.blue.shade100,
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
            child: Text(
              OrderStatusMapper.toText(status),
            ),
          ),
        );

      case OrderStatus.paid:
        return DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColor.onProgress,
            shape: StadiumBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
            child: Text(
              OrderStatusMapper.toText(status),
            ),
          ),
        );

      case OrderStatus.cancelled:
        return DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColor.error,
            shape: StadiumBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
            child: Text(
              OrderStatusMapper.toText(status),
            ),
          ),
        );

      case OrderStatus.completed:
        return DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColor.success,
            shape: StadiumBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
            child: Text(
              OrderStatusMapper.toText(status),
            ),
          ),
        );

      case OrderStatus.refunded:
        return DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.brown.shade100,
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
            child: Text(
              OrderStatusMapper.toText(status),
            ),
          ),
        );
    }
  }
}
