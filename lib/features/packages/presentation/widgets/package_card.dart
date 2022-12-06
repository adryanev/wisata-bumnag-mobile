import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package});
  final Package package;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: 140.w,
      child: Card(
        child: Column(
          children: [
            SizedBox(
              width: 175.w,
              height: 125.h,
              child: CachedNetworkImage(
                imageUrl: package.media[0],
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.black,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFFFB800),
                        size: 10.r,
                      ),
                      Text(
                        ' ${package.reviews.rating ?? 0}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColor.darkGrey,
                        ),
                      ),
                      Text(
                        '(${package.reviews.count})',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColor.darkGrey,
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${rupiahCurrency(
                        package.tickets.firstOrNull?.price,
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
