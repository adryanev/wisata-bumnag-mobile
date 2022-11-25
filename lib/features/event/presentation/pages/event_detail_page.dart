import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/features/event/presentation/blocs/event_detail/event_detail_bloc.dart';
import 'package:wisatabumnag/features/event/presentation/widgets/event_card.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/destination_google_maps.dart';
import 'package:wisatabumnag/shared/widgets/reviewable_card.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    super.key,
    required this.eventId,
  });
  final String? eventId;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with FailureMessageHandler {
  EventDetail? _eventDetail;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EventDetailBloc>()
        ..add(
          EventDetailEvent.started(
            widget.eventId,
          ),
        ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<EventDetailBloc, EventDetailState>(
            listener: (context, state) {
              state.eventDetailOrFailureOption.fold(
                () => null,
                (either) => either.fold(
                  (l) => handleFailure(context, l),
                  (r) => setState(() {
                    _eventDetail = r;
                  }),
                ),
              );
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (_) => context.pushNamed(
                  AppRouter.eventOrder,
                  extra: _eventDetail,
                ),
                unauthenticated: () => showDialog<void>(
                  context: context,
                  builder: (_) => ConfirmationDialog(
                    title: 'Harus Masuk',
                    description: 'Untuk memesan item ini anda harus masuk '
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
                ),
                failed: (failure) => handleFailure(context, failure),
                orElse: () => null,
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<EventDetailBloc, EventDetailState>(
              builder: (context, state) {
                return Text(
                  state.isLoading ? 'Memuat...' : '${state.eventDetail?.name}',
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<EventDetailBloc, EventDetailState>(
              builder: (context, state) {
                if (state.isLoading || state.eventDetail == null) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state.eventDetail != null) {
                  final event = state.eventDetail!;
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
                                imageUrl: event.media[index],
                                fit: BoxFit.fill,
                              );
                            },
                            itemCount: event.media.length,
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
                        EventDetailHeaderWidget(
                          eventDetail: event,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        EventDetailContentWidget(
                          eventDetail: event,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        EventDetailLocationWidget(
                          eventDetail: event,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        EventDetailInformationWidget(
                          eventDetail: event,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        EventDetailReviewAndRecommendationWidget(
                          eventDetail: event,
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
          bottomSheet: BlocBuilder<EventDetailBloc, EventDetailState>(
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
                                  state.eventDetail?.tickets.firstOrNull?.price,
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
                          context.read<AuthenticationBloc>().add(
                                const AuthenticationEvent
                                    .checkAuthenticationStatus(),
                              );
                        },
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

class EventDetailHeaderWidget extends StatelessWidget {
  const EventDetailHeaderWidget({
    super.key,
    required this.eventDetail,
  });
  final EventDetail eventDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventDetail.name,
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
          SizedBox(
            height: 6.h,
          ),
          Column(
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
                    '${eventDetail.reviews.rating ?? 0}',
                    style: TextStyle(
                      color: AppColor.secondBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  )
                ],
              ),
              Text(
                '${eventDetail.reviews.count} Review',
                style: const TextStyle(
                  color: AppColor.darkGrey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            DateTimeFormat.completeDateWithTime.format(eventDetail.startDate) +
                ' - ' +
                DateTimeFormat.completeDateWithTime.format(eventDetail.endDate),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}

class EventDetailContentWidget extends StatelessWidget {
  const EventDetailContentWidget({
    super.key,
    required this.eventDetail,
  });
  final EventDetail eventDetail;
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
            eventDetail.description ?? '',
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

class EventDetailInformationWidget extends StatelessWidget {
  const EventDetailInformationWidget({
    super.key,
    required this.eventDetail,
  });
  final EventDetail eventDetail;

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
            eventDetail.termAndCondition ?? '',
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

class EventDetailReviewAndRecommendationWidget extends StatelessWidget {
  const EventDetailReviewAndRecommendationWidget({
    super.key,
    required this.eventDetail,
  });
  final EventDetail eventDetail;
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
          if (eventDetail.reviews.count > 0) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColor.black),
                children: [
                  TextSpan(
                    text: eventDetail.reviews.rating.toString(),
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
                        '${eventDetail.reviews.count} kali.',
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
                itemCount: eventDetail.reviews.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ReviewableCard(
                    review: eventDetail.reviews.data[index],
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
            height: 210.h,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: eventDetail.recommendations.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      AppRouter.eventDetail,
                      queryParams: {
                        'id': eventDetail.recommendations[index].id.toString(),
                      },
                    );
                  },
                  child: EventCard(
                    event: eventDetail.recommendations[index],
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

class EventDetailLocationWidget extends StatelessWidget {
  const EventDetailLocationWidget({
    super.key,
    required this.eventDetail,
  });
  final EventDetail eventDetail;

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
            eventDetail.address,
            style: TextStyle(
              color: AppColor.secondBlack,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          if (eventDetail.latitude == null ||
              eventDetail.longitude == null) ...[
            const Text('Peta tidak tersedia'),
          ] else ...[
            SizedBox(
              width: 1.sw,
              height: 180.h,
              child: DestinationGoogleMaps(
                latitude: eventDetail.latitude!,
                longitude: eventDetail.longitude!,
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
                      eventDetail.latitude!,
                      eventDetail.longitude!,
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
