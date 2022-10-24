import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/ads_banner_widget.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/home_app_bar.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/home_menu_widget.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/home/popular_destination_widget.dart';
import 'package:wisatabumnag/injector.dart';

class HomeFrontPage extends StatelessWidget {
  const HomeFrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: Column(
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
    );
  }
}
