import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_front/cubit/home_front_cubit.dart';

class AdsBannerWidget extends StatelessWidget {
  const AdsBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 200.h,
      child: BlocBuilder<HomeFrontCubit, HomeFrontState>(
        buildWhen: (previous, current) =>
            previous.adBanners != current.adBanners,
        builder: (context, state) {
          return Swiper(
            autoplay: true,
            autoplayDelay: const Duration(seconds: 2).inMilliseconds,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: state.adBanners[index].media,
                  fit: BoxFit.fill,
                ),
              );
            },
            itemCount: state.adBanners.length,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: AppColor.primary,
                size: 6.r,
                activeSize: 6.r,
                color: AppColor.secondBlack,
              ),
            ),
          );
        },
      ),
    );
  }
}
