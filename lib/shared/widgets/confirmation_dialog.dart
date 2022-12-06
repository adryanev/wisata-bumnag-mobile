import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.dismissText,
    required this.onDismiss,
    required this.onConfirm,
  });

  final String title;
  final String description;
  final String confirmText;
  final String dismissText;
  final VoidCallback onDismiss;
  final VoidCallback? onConfirm;
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
          children: [
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
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: onDismiss,
                    child: Text(
                      dismissText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  WisataButton.primary(onPressed: onConfirm, text: confirmText),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
