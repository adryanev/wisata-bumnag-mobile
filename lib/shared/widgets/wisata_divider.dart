import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';

class WisataDivider extends StatelessWidget {
  const WisataDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 8.h,
      color: AppColor.grey,
    );
  }
}
