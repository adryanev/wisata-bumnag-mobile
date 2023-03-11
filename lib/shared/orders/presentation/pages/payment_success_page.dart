import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({
    required this.status,
    super.key,
  });
  final bool status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: status
                  ? Assets.animations.successLottie.lottie()
                  : Assets.animations.errorLottie.lottie(),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              status ? 'Pemesanan Sukses' : 'Terjadi kesalahan',
              style: GoogleFonts.poppins(
                color: AppColor.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              status ? 'Transaksi berhasil dilakukan' : 'Transaksi dibatalkan',
              style: GoogleFonts.poppins(
                color: AppColor.secondBlack,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(
              height: 28.h,
            ),
            WisataButton.primary(
              onPressed: () {
                context.goNamed(AppRouter.home);
              },
              text: 'Kembali ke halaman awal',
            )
          ],
        ),
      ),
    );
  }
}
