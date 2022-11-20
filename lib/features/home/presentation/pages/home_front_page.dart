import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_front/cubit/home_front_cubit.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/ads_banner_widget.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/home_app_bar.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/home_menu_widget.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/popular_destination_widget.dart';
import 'package:wisatabumnag/injector.dart';

class HomeFrontPage extends StatelessWidget with FailureMessageHandler {
  const HomeFrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<HomeFrontCubit>()
            ..getCurrentLocation()
            ..getAdBanners()
            ..getRecommendations()
            ..getMainCategories(),
        ),
      ],
      child: BlocListener<HomeFrontCubit, HomeFrontState>(
        listener: (context, state) {
          state.adBannerOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
          state.locationOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
          state.recommendationsOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
          state.categoryOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HomeAppBar(),
                SizedBox(
                  height: 20.h,
                ),
                const AdsBannerWidget(),
                SizedBox(
                  height: 20.h,
                ),
                const HomeMenuWidget(),
                SizedBox(
                  height: 20.h,
                ),
                const PopularDestinationWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
