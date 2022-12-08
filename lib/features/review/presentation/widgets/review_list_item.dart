import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class ReviewListItem extends StatelessWidget {
  const ReviewListItem({
    super.key,
    required this.orderDetail,
    required this.isReviewed,
  });
  final OrderDetail orderDetail;
  final bool isReviewed;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 60.w,
                width: 50.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: orderDetail.orderableDetail.media.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                orderDetail.orderableType == r'App\Models\Ticket'
                    ? orderDetail.orderableDetail.name
                    : orderDetail.orderableName,
              ),
              subtitle: Text(
                DateTimeFormat.standard.format(orderDetail.createdAt),
              ),
            ),
            if (!isReviewed) ...[
              SizedBox(
                height: 16.h,
              ),
              Row(
                children: [
                  const Spacer(
                    flex: 3,
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: WisataButton.primary(
                        onPressed: () {
                          context.pushNamed(
                            AppRouter.createReview,
                            extra: orderDetail,
                          );
                        },
                        text: 'Beri Ulasan',
                      ),
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
