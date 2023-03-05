import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisatabumnag/core/utils/colors.dart';

T safeCall<T>({
  required T Function() tryCallback,
  required T Function() exceptionCallBack,
}) {
  try {
    return tryCallback();
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);
    return exceptionCallBack();
  }
}

MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}

final appTheme = ThemeData(
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(
      color: AppColor.secondBlack,
    ),
    color: AppColor.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      color: AppColor.black,
      fontWeight: FontWeight.w600,
      fontSize: 18.sp,
    ),
  ),
  primarySwatch: createMaterialColor(AppColor.primary),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  fontFamily: GoogleFonts.poppins().fontFamily,
  cardTheme: const CardTheme(shadowColor: Color(0xFFDFDFDF)),
  textTheme: Typography.englishLike2018.apply(
    fontSizeFactor: 1.sp,
    bodyColor: AppColor.black,
  ),
);
