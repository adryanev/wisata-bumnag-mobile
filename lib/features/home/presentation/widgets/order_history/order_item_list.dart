import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/order_history/order_status_widget.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Nomor Order: ${order.number}'),
            subtitle: Text(DateTimeFormat.standard.format(order.orderDate)),
            trailing: OrderStatusWidget(status: order.status),
          ),
          if (order.orderDetails.length > 2) ...[
            SizedBox(
              height: 8.h,
            ),
            Text('+ ${order.orderDetails.length - 1}'),
          ],
          SizedBox(
            height: 8.h,
          ),
          Text(
            'Total Pesanan',
          ),
          SizedBox(
            height: 4.h,
          ),
          Text('${rupiahCurrency(order.totalPrice)}'),
        ],
      ),
    );
  }
}
