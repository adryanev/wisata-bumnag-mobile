import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/order_history/order_status_widget.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    required this.order,
    super.key,
  });
  final OrderHistoryItem order;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 70.h,
              width: 60.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: order.media.isEmpty
                    ? const SizedBox()
                    : CachedNetworkImage(
                        imageUrl: order.media.first,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            title: Text(
              order.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: AppColor.black,
              ),
            ),
            subtitle:
                Text(DateTimeFormat.standard.format(order.order.orderDate)),
            trailing: OrderStatusWidget(status: order.order.status),
          ),
          if (order.order.orderDetails.length > 2) ...[
            SizedBox(
              height: 8.h,
            ),
            Text('+ ${order.order.orderDetails.length - 1}'),
          ],
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pesanan',
                    style: TextStyle(
                      color: AppColor.secondBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    '${rupiahCurrency(order.order.totalPrice)}',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 28.h,
                child: WisataButton.primary(
                  onPressed: () {
                    context.pushNamed(AppRouter.order, extra: order);
                  },
                  text: 'Lihat Detail',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
