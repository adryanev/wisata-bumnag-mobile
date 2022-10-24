import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';

class HomeMenuWidget extends StatefulWidget {
  const HomeMenuWidget({super.key});

  @override
  State<HomeMenuWidget> createState() => _HomeMenuWidgetState();
}

class _HomeMenuWidgetState extends State<HomeMenuWidget> {
  final listMenu = [
    HomeMenuItem(
      label: 'Wisata',
      icon: Assets.images.logo.wisata.svg(),
      onClick: () {},
    ),
    HomeMenuItem(
      label: 'Paket Wisata',
      icon: Assets.images.logo.paketWisata.svg(),
      onClick: () {},
    ),
    HomeMenuItem(
      label: 'Event',
      icon: Assets.images.logo.event.svg(),
      onClick: () {},
    ),
    HomeMenuItem(
      label: 'Kuliner',
      icon: Assets.images.logo.kuliner.svg(),
      onClick: () {},
    ),
    HomeMenuItem(
      label: 'Akomodasi',
      icon: Assets.images.logo.akomodasi.svg(),
      onClick: () {},
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
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
