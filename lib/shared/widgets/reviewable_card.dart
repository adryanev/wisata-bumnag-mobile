import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/shared/domain/entities/review.entity.dart';

class ReviewableCard extends StatelessWidget {
  const ReviewableCard({super.key, required this.review});
  final Review review;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: 270.w,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (review.media.isNotEmpty)
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: review.media.first,
                  fit: BoxFit.fill,
                ),
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: AppColor.black),
                            children: [
                              TextSpan(
                                text: review.rating,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '/5',
                                style: TextStyle(
                                  color: AppColor.darkGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateTimeFormat.standard.format(review.createdAt),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.darkGrey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      review.user.name.getOrElse(''),
                      style: TextStyle(
                        color: AppColor.secondBlack,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Text(
                        review.description ?? '',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColor.darkGrey,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
