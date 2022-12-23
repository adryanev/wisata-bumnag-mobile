import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/features/event/domain/entities/event.entity.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});
  final Event event;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210.h,
      width: 140.w,
      child: Card(
        child: Column(
          children: [
            SizedBox(
              width: 175.w,
              height: 125.h,
              child: event.media.isEmpty
                  ? const SizedBox()
                  : CachedNetworkImage(
                      imageUrl: event.media.first,
                      fit: BoxFit.fill,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.black,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Assets.icons.icLocationPin
                              .svg(color: AppColor.darkGrey),
                        ),
                        TextSpan(
                          text: ' ${event.address}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${rupiahCurrency(
                        event.tickets.firstOrNull?.price,
                      )}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: AppColor.secondBlack,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
