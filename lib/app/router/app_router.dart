import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/features/authentication/presentation/pages/login/login_page.dart';
import 'package:wisatabumnag/features/authentication/presentation/pages/register/register_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_page.dart';
import 'package:wisatabumnag/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  const AppRouter._();
  static const home = 'home';
  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
}

final appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode || kProfileMode,
  routes: [
    GoRoute(
      path: '/',
      name: AppRouter.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      name: AppRouter.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/auth/login',
      name: AppRouter.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/register',
      name: AppRouter.register,
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);
