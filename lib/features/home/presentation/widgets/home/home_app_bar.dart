import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_front/cubit/home_front_cubit.dart';
import 'package:wisatabumnag/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
import 'package:wisatabumnag/shared/location/domain/entities/location.entity.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<HomeFrontCubit, HomeFrontState>(
          buildWhen: (previous, current) =>
              previous.location != current.location,
          builder: (context, state) {
            return YourLocationWidget(location: state.location);
          },
        ),
        const Spacer(
          flex: 12,
        ),
        const HomeCartWidget(),
        const Spacer(),

        const HomeNotificationWidget(),
        const Spacer(),
        // const HomeNotificationWidget(),
      ],
    );
  }
}

class HomeNotificationWidget extends StatelessWidget {
  const HomeNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state.notifications.isNotEmpty &&
                  (state.notifications.firstWhereOrNull(
                        (element) => !element.isRead,
                      ) !=
                      null)) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(AppRouter.notification);
                  },
                  child: Assets.icons.icNotificationActive.svg(),
                );
              } else {
                return Assets.icons.icNotification.svg();
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class HomeCartWidget extends StatelessWidget {
  const HomeCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.cartSouvenir.isEmpty) {
                return Assets.icons.icCart.svg();
              } else {
                return InkWell(
                  onTap: () {
                    context.pushNamed(AppRouter.cart);
                  },
                  child: Assets.icons.icCartActive.svg(),
                );
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class YourLocationWidget extends StatelessWidget {
  const YourLocationWidget({
    required this.location,
    super.key,
  });

  final Location? location;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.yourLocation,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10.sp,
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 2.w,
          children: [
            Assets.icons.icLocationPin.svg(),
            Text(
              location?.name ?? 'Sedang memuat lokasi',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColor.black,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ],
        )
      ],
    );
  }
}
