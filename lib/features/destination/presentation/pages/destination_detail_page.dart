import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_detail/destination_detail_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class DestinationDetailPage extends StatelessWidget with FailureMessageHandler {
  const DestinationDetailPage({
    super.key,
    required this.destinationId,
  });
  final String? destinationId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DestinationDetailBloc>()
        ..add(
          DestinationDetailEvent.started(
            destinationId,
          ),
        ),
      child: BlocListener<DestinationDetailBloc, DestinationDetailState>(
        listener: (context, state) {
          state.destinationDetailOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<DestinationDetailBloc, DestinationDetailState>(
              builder: (context, state) {
                return Text(
                  state.isLoading
                      ? 'Memuat...'
                      : '${state.destinationDetail?.name}',
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<DestinationDetailBloc, DestinationDetailState>(
              builder: (context, state) {
                if (state.isLoading || state.destinationDetail == null) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state.destinationDetail != null) {
                  final destination = state.destinationDetail!;
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
                                imageUrl: destination.media[index],
                                fit: BoxFit.fill,
                              );
                            },
                            itemCount: destination.media.length,
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
                        DestinationDetailHeaderWidget(
                          destinationDetail: destination,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        DestinationDetailContentWidget(),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        DestinationDetailLocationWidget(),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        DestinationDetailInformationWidget(),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        DestinationDetailReviewAndRecommendationWidget(),
                        SizedBox(
                          height: 50.h,
                        )
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          bottomSheet:
              BlocBuilder<DestinationDetailBloc, DestinationDetailState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const SizedBox();
              }
              return Container(
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
                      child: Column(
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
                                  state.destinationDetail?.tickets.firstOrNull
                                      ?.price,
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
                        onPressed: () {},
                        text: 'Beli Tiket',
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DestinationDetailHeaderWidget extends StatelessWidget {
  const DestinationDetailHeaderWidget({
    super.key,
    required this.destinationDetail,
  });
  final DestinationDetail destinationDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            destinationDetail.name,
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
                  text: ' ${destinationDetail.address}',
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
                          '${destinationDetail.reviews.rating ?? 0}',
                          style: TextStyle(
                            color: AppColor.secondBlack,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        )
                      ],
                    ),
                    Text(
                      '${destinationDetail.reviews.count} Review',
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
              if (destinationDetail.instagram == null)
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
                        destinationDetail.instagram!,
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
            'Senin - Jumat '
            '\u2022 ${destinationDetail.openingHours ?? "-"} - '
            '${destinationDetail.closingHours ?? "-"}',
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

class DestinationDetailContentWidget extends StatelessWidget {
  const DestinationDetailContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DestinationDetailLocationWidget extends StatelessWidget {
  const DestinationDetailLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DestinationDetailInformationWidget extends StatelessWidget {
  const DestinationDetailInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DestinationDetailReviewAndRecommendationWidget extends StatelessWidget {
  const DestinationDetailReviewAndRecommendationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
