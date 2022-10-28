// Copyright (c) 2022, Adryan Eka Vandra
// https://github.com/adryanev/flutter-template-architecture-template
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/extensions/context_extensions.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/utils.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_bloc.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
import 'package:wisatabumnag/shared/flash/presentation/blocs/cubit/flash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<FlashCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AuthenticationBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FlashCubit, FlashState>(
            listener: (context, state) {
              state.when(
                disappeared: () => null,
                appeared: (message) => context.showSnackbar(
                  message: message,
                ),
              );
            },
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(ScreenUtilSize.width, ScreenUtilSize.height),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  iconTheme: const IconThemeData(
                    color: AppColor.secondBlack,
                  ),
                  color: AppColor.white,
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                primarySwatch: createMaterialColor(AppColor.primary),
                scaffoldBackgroundColor: const Color(0xFFFFFFFF),
                fontFamily: GoogleFonts.poppins().fontFamily,
                cardTheme: const CardTheme(shadowColor: Color(0xFFDFDFDF)),
                textTheme:
                    Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              ),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: appRouter,
              builder: (context, widget) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.sp),
                  child: widget!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
