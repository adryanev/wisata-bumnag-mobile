import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/home/domain/entities/explore.entity.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/explore/explore_bloc.dart';
import 'package:wisatabumnag/injector.dart';

class HomeExplorePage extends StatefulWidget {
  const HomeExplorePage({super.key});

  @override
  State<HomeExplorePage> createState() => _HomeExplorePageState();
}

class _HomeExplorePageState extends State<HomeExplorePage> {
  late final ExploreBloc _exploreBloc;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _exploreBloc = getIt<ExploreBloc>();
    _exploreBloc.add(const ExploreEvent.started());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _exploreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _exploreBloc,
      child: BlocListener<ExploreBloc, ExploreState>(
        listener: (context, state) {
          switch (state.status) {
            case ExploreStatus.initial:
              break;
            case ExploreStatus.failure:
              state.isLoadMore
                  ? _refreshController.loadFailed()
                  : _refreshController.refreshFailed();
              break;
            case ExploreStatus.success:
              state.isLoadMore
                  ? _refreshController.loadComplete()
                  : _refreshController.refreshCompleted();
              break;
          }
          if (state.hasReachedMax) {
            _refreshController.loadNoData();
          }
        },
        child: OverflowBox(
          maxWidth: MediaQuery.of(context).size.width,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Ulasan Pengunjung'),
              actions: [
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationAuthenticated) {
                      return IconButton(
                        onPressed: () {
                          context.pushNamed(AppRouter.review);
                        },
                        icon: const Icon(
                          Icons.star_outline_rounded,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: Dimension.aroundPadding,
                child: BlocBuilder<ExploreBloc, ExploreState>(
                  bloc: _exploreBloc,
                  builder: (context, state) {
                    switch (state.status) {
                      case ExploreStatus.initial:
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      case ExploreStatus.failure:
                        return const Center(
                          child: Text('Cannot fetch explore'),
                        );
                      case ExploreStatus.success:
                        return SmartRefresher(
                          controller: _refreshController,
                          enablePullUp: true,
                          header: const WaterDropHeader(
                            waterDropColor: AppColor.primary,
                          ),
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                          ),
                          onRefresh: () {
                            context
                                .read<ExploreBloc>()
                                .add(const ExploreEvent.refreshed());
                          },
                          onLoading: () {
                            context
                                .read<ExploreBloc>()
                                .add(const ExploreEvent.started());
                          },
                          child: ListView.separated(
                            itemBuilder: (context, index) => ExploreItemWidget(
                              explore: state.explores[index],
                            ),
                            itemCount: state.explores.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 4.h),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExploreItemWidget extends StatelessWidget {
  const ExploreItemWidget({
    required this.explore,
    super.key,
  });
  final Explore explore;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 40 - 20,
          leading: SizedBox(
            height: 30.h,
            width: 30.w,
            child: CircleAvatar(
              backgroundColor: AppColor.grey,
              backgroundImage: CachedNetworkImageProvider(explore.user.avatar!),
            ),
          ),
          title: Text(
            explore.user.name,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColor.secondBlack,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: const Color(0xFFFFB800),
                    size: 16.r,
                  ),
                  Text(
                    ' ${explore.rating}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '/5',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.darkGrey,
                    ),
                  )
                ],
              ),
              Text(
                DateTimeFormat.standard.format(explore.createdAt),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColor.darkGrey,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(explore.reviewable.name),
        SizedBox(
          height: 8.h,
        ),
        Text(
          explore.title,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColor.secondBlack,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        ReadMoreText(
          explore.description,
          textAlign: TextAlign.start,
          colorClickableText: AppColor.primary,
          trimCollapsedText: 'Lihat selengkapnya',
          trimExpandedText: ' Lebih sedikit',
          trimLines: 3,
          trimMode: TrimMode.Line,
          style: const TextStyle(
            color: AppColor.darkGrey,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        if (explore.media.isNotEmpty)
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: explore.media.length,
              itemBuilder: (context, index) => Row(
                children: [
                  SizedBox(
                    height: 80.w,
                    width: 80.w,
                    child: InkWell(
                      onTap: () {
                        showDialog<dynamic>(
                          context: context,
                          builder: (_) {
                            return Dialog(
                              child: SizedBox(
                                child: CachedNetworkImage(
                                  imageUrl: explore.media[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: explore.media[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                ],
              ),
            ),
          ),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }
}
