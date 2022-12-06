import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class GeneralDialog extends StatelessWidget {
  const GeneralDialog._({
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
    required this.lottie,
  });

  factory GeneralDialog.success({
    required String title,
    required String description,
    required String confirmText,
    required VoidCallback onConfirm,
  }) =>
      GeneralDialog._(
        title: title,
        description: description,
        confirmText: confirmText,
        onConfirm: onConfirm,
        lottie: Assets.animations.successLottie
            .lottie(width: 90.w, fit: BoxFit.fill),
      );

  factory GeneralDialog.failure({
    required String title,
    required String description,
    required String confirmText,
    required VoidCallback onConfirm,
  }) =>
      GeneralDialog._(
        title: title,
        description: description,
        confirmText: confirmText,
        onConfirm: onConfirm,
        lottie:
            Assets.animations.errorLottie.lottie(width: 90.w, fit: BoxFit.fill),
      );

  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;
  final LottieBuilder lottie;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 16.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                lottie,
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColor.secondBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            WisataButton.primary(onPressed: onConfirm, text: confirmText)
          ],
        ),
      ),
    );
  }
}
