import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_front/cubit/home_front_cubit.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

class HomeMenuWidget extends StatefulWidget {
  const HomeMenuWidget({super.key});

  @override
  State<HomeMenuWidget> createState() => _HomeMenuWidgetState();
}

class _HomeMenuWidgetState extends State<HomeMenuWidget> {
  final listMenu = [
    BlocSelector<HomeFrontCubit, HomeFrontState, Category?>(
      selector: (state) {
        final category = state.category
            ?.firstWhere((element) => element.name.toLowerCase() == 'wisata');
        return category;
      },
      builder: (context, state) {
        return HomeMenuItem(
          label: 'Wisata',
          icon: Assets.images.logo.wisata.svg(),
          onClick: () {
            context.pushNamed(AppRouter.destination, extra: state);
          },
        );
      },
    ),
    BlocSelector<HomeFrontCubit, HomeFrontState, Category?>(
      selector: (state) {
        final category = state.category
            ?.firstWhere((element) => element.name.toLowerCase() == 'package');
        return category;
      },
      builder: (context, state) {
        return HomeMenuItem(
          label: 'Paket Wisata',
          icon: Assets.images.logo.paketWisata.svg(),
          onClick: () {
            context.pushNamed(AppRouter.packages, extra: state);
          },
        );
      },
    ),
    BlocSelector<HomeFrontCubit, HomeFrontState, Category?>(
      selector: (state) {
        final category = state.category
            ?.firstWhere((element) => element.name.toLowerCase() == 'event');
        return category;
      },
      builder: (context, state) {
        return HomeMenuItem(
          label: 'Event',
          icon: Assets.images.logo.event.svg(),
          onClick: () {
            context.pushNamed(AppRouter.events, extra: state);
          },
        );
      },
    ),
    BlocSelector<HomeFrontCubit, HomeFrontState, Category?>(
      selector: (state) {
        final category = state.category
            ?.firstWhere((element) => element.name.toLowerCase() == 'kuliner');
        return category;
      },
      builder: (context, state) {
        return HomeMenuItem(
          label: 'Kuliner',
          icon: Assets.images.logo.kuliner.svg(),
          onClick: () {
            context.pushNamed(AppRouter.destination, extra: state);
          },
        );
      },
    ),
    BlocSelector<HomeFrontCubit, HomeFrontState, Category?>(
      selector: (state) {
        final category = state.category?.firstWhere(
          (element) => element.name.toLowerCase() == 'akomodasi',
        );
        return category;
      },
      builder: (context, state) {
        return HomeMenuItem(
          label: 'Akomodasi',
          icon: Assets.images.logo.akomodasi.svg(),
          onClick: () {
            context.pushNamed(AppRouter.destination, extra: state);
          },
        );
      },
    ),
    HomeMenuItem(
      label: 'Suvenir',
      icon: Assets.images.logo.suvenir.svg(),
      onClick: () {},
    ),
    HomeMenuItem(
      label: 'Profil Nagari',
      icon: Assets.images.logo.profilNagari.svg(),
      onClick: () {},
    ),
    HomeMenuItem(
      label: 'Instagram',
      icon: Assets.images.logo.instagram.image(),
      onClick: () {},
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        semanticChildCount: listMenu.length,
        shrinkWrap: true,
        children: listMenu,
      ),
    );
  }
}

class HomeMenuItem extends StatelessWidget {
  const HomeMenuItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onClick,
  });
  final String label;
  final Widget icon;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(
            height: 5.h,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
