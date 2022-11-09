import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WisataButton extends StatelessWidget {
  const WisataButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  factory WisataButton.primary({
    required VoidCallback? onPressed,
    required String text,
  }) =>
      WisataButton(onPressed: onPressed, text: text);

  factory WisataButton.loading() =>
      const WisataButton(onPressed: null, text: '');

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // padding: EdgeInsets.symmetric(vertical: 13.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
      child: text.isEmpty
          ? const CircularProgressIndicator.adaptive()
          : Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
