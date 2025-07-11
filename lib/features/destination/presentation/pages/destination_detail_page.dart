import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_detail/destination_detail_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/destination_card.dart';
import 'package:wisatabumnag/shared/widgets/destination_google_maps.dart';
import 'package:wisatabumnag/shared/widgets/destination_non_ticket_card.dart';
import 'package:wisatabumnag/shared/widgets/reviewable_card.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class DestinationDetailPage extends StatefulWidget {
  const DestinationDetailPage({
    required this.destinationId,
    super.key,
  });
  final String? destinationId;

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage>
    with FailureMessageHandler {
  DestinationDetail? _destinationDetail;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DestinationDetailBloc>()
        ..add(
          DestinationDetailEvent.started(
            widget.destinationId,
          ),
        ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<DestinationDetailBloc, DestinationDetailState>(
            listener: (context, state) {
              state.destinationDetailOrFailureOption.fold(
                () => null,
                (either) => either.fold(
                  (l) => handleFailure(context, l),
                  (r) => setState(() {
                    _destinationDetail = r;
                  }),
                ),
              );
            },
          ),
        ],
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
                        DestinationDetailContentWidget(
                          destinationDetail: destination,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        DestinationDetailLocationWidget(
                          destinationDetail: destination,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        DestinationDetailInformationWidget(
                          destinationDetail: destination,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        DestinationDetailReviewAndRecommendationWidget(
                          destinationDetail: destination,
                        ),
                        SizedBox(
                          height: 100.h,
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
              if (state.destinationDetail?.categories.firstWhereOrNull(
                    (element) => element.id == 1 || element.parentId == 1,
                  ) ==
                  null) {
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
                      child:
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          if (state is AuthenticationAuthenticated) {
                            return WisataButton.primary(
                              onPressed: () {
                                context.pushNamed(
                                  AppRouter.destinationOrder,
                                  extra: _destinationDetail,
                                );
                              },
                              text: 'Beli Tiket',
                            );
                          }
                          return WisataButton.primary(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (_) => ConfirmationDialog(
                                  title: 'Harus Masuk',
                                  description:
                                      'Untuk memesan item ini anda harus masuk '
                                      'terlebih dahulu.',
                                  confirmText: 'Masuk',
                                  dismissText: 'Batal',
                                  onDismiss: () {
                                    Navigator.pop(context);
                                  },
                                  onConfirm: () {
                                    context.pushNamed(AppRouter.login);
                                  },
                                ),
                              );
                            },
                            text: 'Beli Tiket',
                          );
                        },
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
    required this.destinationDetail,
    super.key,
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
              if (destinationDetail.categories.firstWhereOrNull(
                    (element) => element.id == 1 || element.parentId == 1,
                  ) ==
                  null) ...[
                if (destinationDetail.instagram == null)
                  const SizedBox()
                else
                  Flexible(
                    flex: 6,
                    child: InkWell(
                      onTap: () async {
                        final url =
                            'instagram://user?username=${destinationDetail.instagram?.replaceFirst('@', '')}';
                        await launchUrlString(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
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
                  ),
              ] else ...[
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
                    child: InkWell(
                      onTap: () async {
                        debugPrint('instagram tapped');
                        final url =
                            'instagram://user?username=${destinationDetail.instagram?.replaceFirst('@', '')}';
                        await launchUrlString(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
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
                  ),
              ]
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
            '${destinationDetail.workingDay ?? '-'} '
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
  const DestinationDetailContentWidget({
    required this.destinationDetail,
    super.key,
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
            destinationDetail.description,
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

class DestinationDetailLocationWidget extends StatelessWidget {
  const DestinationDetailLocationWidget({
    required this.destinationDetail,
    super.key,
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
            destinationDetail.address,
            style: TextStyle(
              color: AppColor.secondBlack,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          if (destinationDetail.latitude == null ||
              destinationDetail.longitude == null) ...[
            const Text('Peta tidak tersedia'),
          ] else ...[
            SizedBox(
              width: 1.sw,
              height: 180.h,
              child: DestinationGoogleMaps(
                latitude: destinationDetail.latitude!,
                longitude: destinationDetail.longitude!,
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
                      destinationDetail.latitude!,
                      destinationDetail.longitude!,
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

class DestinationDetailInformationWidget extends StatelessWidget {
  const DestinationDetailInformationWidget({
    required this.destinationDetail,
    super.key,
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
            'Info Penting',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            destinationDetail.description,
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

class DestinationDetailReviewAndRecommendationWidget extends StatelessWidget {
  const DestinationDetailReviewAndRecommendationWidget({
    required this.destinationDetail,
    super.key,
  });
  final DestinationDetail destinationDetail;
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
              // const Spacer(),
              // TextButton(onPressed: () {}, child: const Text('Lihat Semua'))
            ],
          ),
          if (destinationDetail.reviews.count > 0) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColor.black),
                children: [
                  TextSpan(
                    text: destinationDetail.reviews.rating.toString(),
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
                        '${destinationDetail.reviews.count} kali.',
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
                itemCount: destinationDetail.reviews.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ReviewableCard(
                    review: destinationDetail.reviews.data[index],
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
            height: 220.h,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: destinationDetail.recommendations.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      AppRouter.destinationDetail,
                      queryParameters: {
                        'id': destinationDetail.recommendations[index].id
                            .toString(),
                      },
                    );
                  },
                  child: (destinationDetail.categories.firstWhereOrNull(
                            (element) =>
                                element.id == 1 || element.parentId == 1,
                          ) ==
                          null)
                      ? DestinationNonTicketCard(
                          destination: destinationDetail.recommendations[index],
                        )
                      : DestinationCard(
                          destination: destinationDetail.recommendations[index],
                        ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
