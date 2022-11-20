import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_account_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_explore_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_front_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_history_order_page.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with FailureMessageHandler {
  final pages = <Widget>[
    const HomeFrontPage(),
    const HomeExplorePage(),
    const HomeHistoryOrderPage(),
    const HomeAccountPage()
  ];
  final navigationItem = [
    BottomNavigationBarItem(
      icon: Assets.icons.icHome.svg(),
      activeIcon: Assets.icons.icHomeActive.svg(),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Assets.icons.icExplore.svg(),
      activeIcon: Assets.icons.icExploreActive.svg(),
      label: 'Explore',
    ),
    BottomNavigationBarItem(
      icon: Assets.icons.icHistory.svg(),
      activeIcon: Assets.icons.icHistoryActive.svg(),
      label: 'History',
    ),
    BottomNavigationBarItem(
      icon: Assets.icons.icAccount.svg(),
      activeIcon: Assets.icons.icAccountActive.svg(),
      label: 'Account',
    )
  ];

  @override
  void initState() {
    context
        .read<AuthenticationBloc>()
        .add(const AuthenticationEvent.checkAuthenticationStatus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) => context.read<CartBloc>().add(
                const CartEvent.started(),
              ),
          orElse: () => null,
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: Dimension.aroundPadding,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return pages[state.navigationBarIndex];
              },
            ),
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return state.maybeWhen(
              authenticated: (_) => BlocSelector<HomeBloc, HomeState, int>(
                selector: (state) => state.navigationBarIndex,
                builder: (context, state) {
                  return BottomNavigationBar(
                    showSelectedLabels: true,
                    items: navigationItem,
                    currentIndex: state,
                    onTap: (value) {
                      context
                          .read<HomeBloc>()
                          .add(HomeEvent.bottomNavigatonChanged(value));
                    },
                  );
                },
              ),
              unauthenticated: () => BlocSelector<HomeBloc, HomeState, int>(
                selector: (state) => state.navigationBarIndex,
                builder: (context, state) {
                  return BottomNavigationBar(
                    showSelectedLabels: true,
                    items: navigationItem,
                    currentIndex: state,
                    onTap: (value) {
                      if (value == 2 || value == 3) {
                        context.pushNamed(AppRouter.login);
                      }
                      context
                          .read<HomeBloc>()
                          .add(HomeEvent.bottomNavigatonChanged(value));
                    },
                  );
                },
              ),
              orElse: () => const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}
