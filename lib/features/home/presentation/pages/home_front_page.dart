import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_front/cubit/home_front_cubit.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/ads_banner_widget.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/home_app_bar.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/home_menu_widget.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/popular_destination_widget.dart';
import 'package:wisatabumnag/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:wisatabumnag/injector.dart';

class HomeFrontPage extends StatelessWidget with FailureMessageHandler {
  const HomeFrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => getIt<HomeFrontCubit>()
            ..getCurrentLocation()
            ..getAdBanners()
            ..getRecommendations()
            ..getMainCategories(),
        ),
        BlocProvider(
          create: (context) => getIt<NotificationBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeFrontCubit, HomeFrontState>(
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
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationAuthenticated) {
                context
                    .read<NotificationBloc>()
                    .add(const NotificationEvent.started());
              }
            },
          ),
        ],
        child: SingleChildScrollView(
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
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationAuthenticated) {
                      if (state.user.roles?.toLowerCase() == 'ticketer') {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                context.pushNamed(AppRouter.scan);
                              },
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    side: const BorderSide(
                                      color: AppColor.borderStroke,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: AppColor.secondBlack,
                                  ),
                                  title: Text(
                                    'Scan QR Pengunjung',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppColor.secondBlack,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColor.secondBlack,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        );
                      }
                    }
                    return const SizedBox();
                  },
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
