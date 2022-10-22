import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';

class AdsBannerWidget extends StatelessWidget {
  const AdsBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 200.h,
      child: Swiper(
        autoplay: true,
        autoplayDelay: const Duration(seconds: 2).inMilliseconds,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Assets.images.bannerPlaceholder.image(fit: BoxFit.cover),
          );
        },
        itemCount: 5,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: AppColor.primary,
            size: 6.r,
            activeSize: 6.r,
            color: AppColor.secondBlack,
          ),
        ),
      ),
    );
  }
}
