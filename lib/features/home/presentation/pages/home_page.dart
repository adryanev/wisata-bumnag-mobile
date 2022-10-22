import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_account_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_explore_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_front_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_history_order_page.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/l10n/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = <Widget>[
    const HomeFrontPage(),
    const HomeExplorePage(),
    const HomeHistoryOrderPage(),
    const HomeAccountPage()
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Dimension.aroundPadding,
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Assets.icons.icHome.svg(),
            activeIcon: Assets.icons.icHomeActive.svg(),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.icExplore.svg(),
            activeIcon: Assets.icons.icExploreActive.svg(),
            label: l10n.explore,
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.icHistory.svg(),
            activeIcon: Assets.icons.icHistoryActive.svg(),
            label: l10n.history,
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.icAccount.svg(),
            activeIcon: Assets.icons.icAccountActive.svg(),
            label: l10n.account,
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavigationTap,
      ),
    );
  }

  void _onNavigationTap(int value) {
    //TODO: check if user is logged in or not,
    if (value == 3) {
      context.pushNamed(AppRouter.login);
      return;
    }
    setState(() {
      _selectedIndex = value;
    });
  }
}
