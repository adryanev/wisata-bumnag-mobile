import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';

class SplashPage extends StatelessWidget with FailureMessageHandler {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SplashBloc>()..add(const SplashEvent.fetchApiUrl()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          state.apiUrlOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context.read<SplashBloc>().add(
                    SplashEvent.saveApiUrl(r),
                  ),
            ),
          );
          state.saveApiUrlOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context.read<SplashBloc>().add(
                    const SplashEvent.fetchApiKey(),
                  ),
            ),
          );

          state.apiKeyOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context.read<SplashBloc>().add(
                    SplashEvent.saveApiKey(r),
                  ),
            ),
          );

          state.saveApiKeyOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context.read<SplashBloc>().add(
                    const SplashEvent.fetchSalt(),
                  ),
            ),
          );

          state.saltOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context.read<SplashBloc>().add(
                    SplashEvent.saveSalt(r),
                  ),
            ),
          );

          state.saveSaltOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context.goNamed(AppRouter.home),
            ),
          );
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Assets.images.appIconRedText.svg(),
            ),
          ),
        ),
      ),
    );
  }
}
