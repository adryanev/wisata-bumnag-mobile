import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/features/authentication/presentation/pages/login/login_page.dart';
import 'package:wisatabumnag/features/authentication/presentation/pages/register/register_page.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/presentation/pages/destination_detail_page.dart';
import 'package:wisatabumnag/features/destination/presentation/pages/destination_list_page.dart';
import 'package:wisatabumnag/features/destination/presentation/pages/destination_order_page.dart';
import 'package:wisatabumnag/features/home/presentation/pages/home_page.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/features/packages/presentation/pages/package_detail_page.dart';
import 'package:wisatabumnag/features/packages/presentation/pages/package_list_page.dart';
import 'package:wisatabumnag/features/packages/presentation/pages/package_order_page.dart';
import 'package:wisatabumnag/features/splash/presentation/pages/splash_page.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/presentation/pages/online_payment_page.dart';
import 'package:wisatabumnag/shared/orders/presentation/pages/payment_page.dart';
import 'package:wisatabumnag/shared/orders/presentation/pages/payment_success_page.dart';

class AppRouter {
  const AppRouter._();
  static const home = 'home';
  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
  static const destination = 'destination';
  static const destinationDetail = 'destination-detail';
  static const destinationOrder = 'destination-order';
  static const payment = 'payment';
  static const paymentDone = 'payment-done';
  static const onlinePayment = 'online-payment';
  static const packages = 'packages';
  static const packageDetail = 'package-detail';
  static const packageOrder = 'package-order';
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
    GoRoute(
      path: '/destinations',
      name: AppRouter.destination,
      builder: (context, state) {
        final category = state.extra as Category?;

        return DestinationListPage(category: category);
      },
      routes: [
        GoRoute(
          path: 'detail',
          name: AppRouter.destinationDetail,
          builder: (context, state) {
            final id = state.queryParams['id'];
            return DestinationDetailPage(destinationId: id);
          },
        ),
        GoRoute(
          path: 'order',
          name: AppRouter.destinationOrder,
          builder: (context, state) {
            final destination = state.extra as DestinationDetail?;
            if (destination == null) {
              return const SizedBox();
            }
            return DestinationOrder(destinationDetail: destination);
          },
        ),
      ],
    ),
    GoRoute(
      path: 'payment',
      name: AppRouter.payment,
      builder: (context, state) {
        final order = state.extra as Order?;
        if (order == null) {
          return const SizedBox();
        }

        return PaymentPage(order: order);
      },
      routes: [
        GoRoute(
          path: 'payment-done',
          name: AppRouter.paymentDone,
          builder: (context, state) {
            final status = state.extra as bool?;
            if (status == null) return const SizedBox();
            return PaymentSuccessPage(
              status: status,
            );
          },
        ),
        GoRoute(
          path: 'online-payment',
          name: AppRouter.onlinePayment,
          builder: (context, state) {
            final url = state.extra as String?;
            if (url == null) return const SizedBox();
            return OnlinePaymentPage(
              url: url,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/packages',
      name: AppRouter.packages,
      builder: (context, state) {
        final category = state.extra as Category?;

        return PackageListPage(
          category: category,
        );
      },
      routes: [
        GoRoute(
          path: 'detail',
          name: AppRouter.packageDetail,
          builder: (context, state) {
            final id = state.queryParams['id'];
            return PackageDetailPage(packageId: id);
          },
        ),
        GoRoute(
          path: 'order',
          name: AppRouter.packageOrder,
          builder: (context, state) {
            final package = state.extra as PackageDetail?;
            if (package == null) {
              return const SizedBox();
            }
            return PackageOrderPage(packageDetail: package);
          },
        ),
      ],
    ),
  ],
);
