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
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/features/packages/presentation/blocs/package_detail/package_detail_bloc.dart';
import 'package:wisatabumnag/features/packages/presentation/widgets/package_card.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/reviewable_card.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class PackageDetailPage extends StatefulWidget {
  const PackageDetailPage({
    super.key,
    required this.packageId,
  });
  final String? packageId;

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage>
    with FailureMessageHandler {
  PackageDetail? _packageDetail;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PackageDetailBloc>()
        ..add(
          PackageDetailEvent.started(
            widget.packageId,
          ),
        ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PackageDetailBloc, PackageDetailState>(
            listener: (context, state) {
              state.packageDetailOrFailureOption.fold(
                () => null,
                (either) => either.fold(
                  (l) => handleFailure(context, l),
                  (r) => setState(() {
                    _packageDetail = r;
                  }),
                ),
              );
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (_) => context.pushNamed(
                  AppRouter.packageOrder,
                  extra: _packageDetail,
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
            title: BlocBuilder<PackageDetailBloc, PackageDetailState>(
              builder: (context, state) {
                return Text(
                  state.isLoading
                      ? 'Memuat...'
                      : '${state.packageDetail?.name}',
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<PackageDetailBloc, PackageDetailState>(
              builder: (context, state) {
                if (state.isLoading || state.packageDetail == null) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state.packageDetail != null) {
                  final package = state.packageDetail!;
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
                                imageUrl: package.media[index],
                                fit: BoxFit.fill,
                              );
                            },
                            itemCount: package.media.length,
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
                        PackageDetailHeaderWidget(
                          packageDetail: package,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        PackageDetailContentWidget(
                          packageDetail: package,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        PackageDetailInformationWidget(
                          packageDetail: package,
                        ),
                        Divider(
                          thickness: 8.h,
                          color: AppColor.grey,
                        ),
                        PackageDetailReviewAndRecommendationWidget(
                          packageDetail: package,
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
          bottomSheet: BlocBuilder<PackageDetailBloc, PackageDetailState>(
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
                                  state.packageDetail?.tickets.firstOrNull
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

class PackageDetailHeaderWidget extends StatelessWidget {
  const PackageDetailHeaderWidget({
    super.key,
    required this.packageDetail,
  });
  final PackageDetail packageDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            packageDetail.name,
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
                      '${packageDetail.reviews.rating ?? 0}',
                      style: TextStyle(
                        color: AppColor.secondBlack,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    )
                  ],
                ),
                Text(
                  '${packageDetail.reviews.count} Review',
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
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }
}

class PackageDetailContentWidget extends StatelessWidget {
  const PackageDetailContentWidget({
    super.key,
    required this.packageDetail,
  });
  final PackageDetail packageDetail;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harga Termasuk',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            packageDetail.priceInclude ?? '',
            style: TextStyle(
              color: AppColor.secondBlack,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            'Harga Tidak Termasuk',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            packageDetail.priceExclude ?? '',
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

class PackageDetailInformationWidget extends StatelessWidget {
  const PackageDetailInformationWidget({
    super.key,
    required this.packageDetail,
  });
  final PackageDetail packageDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivitas',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            packageDetail.activities ?? '',
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

class PackageDetailReviewAndRecommendationWidget extends StatelessWidget {
  const PackageDetailReviewAndRecommendationWidget({
    super.key,
    required this.packageDetail,
  });
  final PackageDetail packageDetail;
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
          if (packageDetail.reviews.count > 0) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColor.black),
                children: [
                  TextSpan(
                    text: packageDetail.reviews.rating.toString(),
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
                        '${packageDetail.reviews.count} kali.',
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
                itemCount: packageDetail.reviews.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ReviewableCard(
                    review: packageDetail.reviews.data[index],
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
              itemCount: packageDetail.recommendations.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      AppRouter.packageDetail,
                      queryParams: {
                        'id':
                            packageDetail.recommendations[index].id.toString(),
                      },
                    );
                  },
                  child: PackageCard(
                    package: packageDetail.recommendations[index],
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
