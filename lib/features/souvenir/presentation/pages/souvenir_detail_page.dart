import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/extensions/language/pair.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir_detail.entity.dart';
import 'package:wisatabumnag/features/souvenir/presentation/blocs/souvenir_detail/souvenir_detail_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/destination_google_maps.dart';
import 'package:wisatabumnag/shared/widgets/reviewable_card.dart';
import 'package:wisatabumnag/shared/widgets/souvenir_item_card.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class SouvenirDetailPage extends StatelessWidget with FailureMessageHandler {
  const SouvenirDetailPage({
    super.key,
    required this.destinationSouvenir,
    required this.souvenir,
  });
  final DestinationSouvenir destinationSouvenir;
  final Souvenir souvenir;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SouvenirDetailBloc>()
        ..add(
          SouvenirDetailEvent.started(
            souvenir.id,
          ),
        ),
      child: BlocListener<SouvenirDetailBloc, SouvenirDetailState>(
        listener: (context, state) {
          state.souvenirDetailOrFailureOption.fold(
            () => null,
            (either) =>
                either.fold((l) => handleFailure(context, l), (r) => null),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(souvenir.name.toTitleCase()),
          ),
          body: BlocBuilder<SouvenirDetailBloc, SouvenirDetailState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state.souvenirDetail == null) {
                return const SizedBox();
              }
              final souvenirDetail = state.souvenirDetail!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 250.h,
                      width: 1.sw,
                      child: Swiper(
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: souvenir.media[index],
                            fit: BoxFit.fill,
                          );
                        },
                        itemCount: souvenir.media.length,
                        pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                            activeColor: AppColor.primary,
                            size: 8.r,
                            activeSize: 10.r,
                            color: AppColor.secondBlack,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    DestinationSouvenirHeaderWidget(
                      destinationSouvenir: destinationSouvenir,
                      souvenir: souvenirDetail,
                    ),
                    Divider(
                      thickness: 8.h,
                      color: AppColor.grey,
                    ),
                    DestinationSouvenirContentWidget(
                      souvenirDetail: souvenirDetail,
                    ),
                    Divider(
                      thickness: 8.h,
                      color: AppColor.grey,
                    ),
                    DestinationSouvenirLocationWidget(
                      destinationSouvenir: destinationSouvenir,
                    ),
                    Divider(
                      thickness: 8.h,
                      color: AppColor.grey,
                    ),
                    DestinationSouvenirInformationWidget(
                      souvenirDetail: souvenirDetail,
                    ),
                    Divider(
                      thickness: 8.h,
                      color: AppColor.grey,
                    ),
                    DestinationSouvenirReviewAndRecommendationWidget(
                      destinationSouvenir: destinationSouvenir,
                      souvenirDetail: souvenirDetail,
                    ),
                    SizedBox(
                      height: 100.h,
                    )
                  ],
                ),
              );
            },
          ),
          bottomSheet: Container(
            height: 80.h,
            padding: Dimension.aroundPadding,
            decoration: const BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 1,
                  blurRadius: 1,
                  color: AppColor.borderStroke,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harga mulai dari',
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 11.sp,
                        ),
                      ),
                      Text(
                        rupiahCurrency(
                              souvenir.price,
                            ) ??
                            '0',
                        style: TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 120.w,
                  child: WisataButton.primary(
                    onPressed: () {
                      context.read<CartBloc>().add(
                            CartEvent.decisionChecked(
                              Pair(destinationSouvenir, souvenir),
                            ),
                          );
                    },
                    text: '+ Keranjang',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DestinationSouvenirHeaderWidget extends StatelessWidget {
  const DestinationSouvenirHeaderWidget({
    super.key,
    required this.destinationSouvenir,
    required this.souvenir,
  });
  final DestinationSouvenir destinationSouvenir;
  final SouvenirDetail souvenir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            souvenir.name.toTitleCase(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 4.h,
          ),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Assets.icons.icLocationPin.svg(
                    color: AppColor.primary,
                    height: 14.h,
                    width: 14.w,
                  ),
                ),
                TextSpan(
                  text: ' ${destinationSouvenir.address}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColor.secondBlack,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFFFB800),
                          size: 24.r,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          '${souvenir.reviews.rating ?? 0}',
                          style: TextStyle(
                            color: AppColor.secondBlack,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        )
                      ],
                    ),
                    Text(
                      '${souvenir.reviews.count} Review',
                      style: const TextStyle(
                        color: AppColor.darkGrey,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 25.h,
                width: 3.w,
                color: AppColor.grey,
              ),
              const Spacer(),
              if (destinationSouvenir.instagram == null)
                const SizedBox()
              else
                Flexible(
                  flex: 6,
                  child: Row(
                    children: [
                      Assets.icons.icInstagramSolid.svg(),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        destinationSouvenir.instagram!,
                        style: const TextStyle(
                          color: AppColor.darkGrey,
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            'Jadwal Buka',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
          Text(
            '${destinationSouvenir.workingDay ?? '-'} '
            '\u2022 ${destinationSouvenir.openingHours ?? "-"} - '
            '${destinationSouvenir.closingHours ?? "-"}',
            style: const TextStyle(
              color: AppColor.darkGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }
}

class DestinationSouvenirContentWidget extends StatelessWidget {
  const DestinationSouvenirContentWidget({
    super.key,
    required this.souvenirDetail,
  });
  final SouvenirDetail souvenirDetail;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            '${souvenirDetail.description}',
            style: TextStyle(
              color: AppColor.secondBlack,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationSouvenirLocationWidget extends StatelessWidget {
  const DestinationSouvenirLocationWidget({
    super.key,
    required this.destinationSouvenir,
  });
  final DestinationSouvenir destinationSouvenir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lokasi',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            destinationSouvenir.address ?? '',
            style: TextStyle(
              color: AppColor.secondBlack,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          if (destinationSouvenir.latitude == null ||
              destinationSouvenir.longitude == null) ...[
            const Text('Peta tidak tersedia'),
          ] else ...[
            SizedBox(
              width: 1.sw,
              height: 180.h,
              child: DestinationGoogleMaps(
                latitude: destinationSouvenir.latitude!,
                longitude: destinationSouvenir.longitude!,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Center(
              child: SizedBox(
                height: 35.h,
                width: 180.w,
                child: ElevatedButton(
                  onPressed: () {
                    MapsLauncher.launchCoordinates(
                      destinationSouvenir.latitude!,
                      destinationSouvenir.longitude!,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.near_me,
                        size: 18.r,
                      ),
                      const Text('Petunjuk Arah'),
                      Icon(
                        Icons.navigate_next,
                        size: 18.r,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}

class DestinationSouvenirInformationWidget extends StatelessWidget {
  const DestinationSouvenirInformationWidget({
    super.key,
    required this.souvenirDetail,
  });
  final SouvenirDetail souvenirDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Syarat dan Ketentuan',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            souvenirDetail.termAndConditions ?? '',
            style: TextStyle(
              color: AppColor.secondBlack,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationSouvenirReviewAndRecommendationWidget extends StatelessWidget {
  const DestinationSouvenirReviewAndRecommendationWidget({
    super.key,
    required this.souvenirDetail,
    required this.destinationSouvenir,
  });
  final SouvenirDetail souvenirDetail;
  final DestinationSouvenir destinationSouvenir;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Review',
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Lihat Semua'))
            ],
          ),
          if (souvenirDetail.reviews.count > 0) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColor.black),
                children: [
                  TextSpan(
                    text: souvenirDetail.reviews.rating.toString(),
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
                  WidgetSpan(
                    child: SizedBox(
                      width: 4.w,
                    ),
                  ),
                  TextSpan(
                    text: 'Telah direview sebanyak '
                        '${souvenirDetail.reviews.count} kali.',
                    style: TextStyle(
                      color: AppColor.darkGrey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 1.sw,
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: souvenirDetail.reviews.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ReviewableCard(
                    review: souvenirDetail.reviews.data[index],
                  );
                },
              ),
            ),
          ] else
            const Text(
              'Belum ada ulasan',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColor.darkGrey,
              ),
            ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            'Mungkin kamu suka',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          SizedBox(
            width: 1.sw,
            height: 240.h,
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: souvenirDetail.recommendations.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SouvenirItemCard(
                      souvenir: souvenirDetail.recommendations[index],
                      onAddToCart: () {
                        context.read<CartBloc>().add(
                              CartEvent.decisionChecked(
                                Pair(
                                  destinationSouvenir,
                                  souvenirDetail.recommendations[index],
                                ),
                              ),
                            );
                      },
                      onTap: () {
                        context.pushNamed(
                          AppRouter.souvenirDetail,
                          extra: {
                            'souvenir': souvenirDetail.recommendations[index],
                            'destinationSouvenir': destinationSouvenir
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
