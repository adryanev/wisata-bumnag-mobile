import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class CartListPage extends StatelessWidget {
  const CartListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Suvenir'),
      ),
      body: SafeArea(child: Column()),
      bottomSheet: Container(
        height: 80.h,
        padding: Dimension.aroundPadding,
        decoration: const BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.outer,
              spreadRadius: 1,
              blurRadius: 1,
              color: AppColor.borderStroke,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Harga',
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 11.sp,
                    ),
                  ),
                  Text(
                    rupiahCurrency(
                          0000,
                        ) ??
                        '0',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 120.w,
              child: WisataButton.primary(
                onPressed: () {},
                text: 'Beli (2)',
              ),
            )
          ],
        ),
      ),
    );
  }
}
