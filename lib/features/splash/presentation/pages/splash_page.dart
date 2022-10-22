import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    useFuture(
      Future.delayed(
        const Duration(seconds: 3),
        () {
          context.goNamed(AppRouter.home);
        },
      ),
      preserveState: false,
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Assets.images.appIconRedText.svg(),
        ),
      ),
    );
  }
}
