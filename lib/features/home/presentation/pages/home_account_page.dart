import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_bloc.dart';

class HomeAccountPage extends StatelessWidget {
  const HomeAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              context.pushNamed(AppRouter.editProfile);
            },
            icon: const Icon(Icons.settings_rounded, color: AppColor.darkGrey),
          ),
        ),
        const Spacer(),
        const ProfileWidget(),
        const Spacer(
          flex: 3,
        )
      ],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox(),
          unauthenticated: () => const SizedBox(),
          authenticated: (user) => Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 60.r,
                  backgroundImage: CachedNetworkImageProvider(
                    user.avatar ?? 'https://source.unsplash.com/random',
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  user.name.getOrCrash(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(user.emailAddress.getOrCrash()),
                Text(
                  user.phoneNumber?.getOrCrash() ?? '',
                ),
                SizedBox(
                  height: 30.h,
                ),
                TextButton(
                  onPressed: () {
                    context
                      ..read<AuthenticationBloc>()
                          .add(const AuthenticationEvent.loggedOut())
                      ..read<HomeBloc>()
                          .add(const HomeEvent.bottomNavigatonChanged(0));
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
          failed: (failure) => const SizedBox(),
        );
      },
    );
  }
}
