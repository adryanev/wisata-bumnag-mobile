import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190.h,
      width: 140.w,
      child: Card(
        child: Column(
          children: [
            SizedBox(
              width: 175.w,
              height: 110.h,
              child:
                  Assets.images.destinationPlaceholder.image(fit: BoxFit.fill),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pulau Sultan',
                    style: TextStyle(
                      fontSize: 10.sp,
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
                          text: ' Pesisir Selatan, Sumatera Barat',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFFFB800),
                        size: 8.r,
                      ),
                      Text(
                        ' 4.8',
                        style:
                            TextStyle(fontSize: 8.sp, color: AppColor.darkGrey),
                      ),
                      Text(
                        '(120)',
                        style:
                            TextStyle(fontSize: 8.sp, color: AppColor.darkGrey),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Rp 1.000.000',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
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
