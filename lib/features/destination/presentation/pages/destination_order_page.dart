import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class DestinationOrder extends StatelessWidget {
  const DestinationOrder({
    super.key,
    required this.destinationDetail,
  });
  final DestinationDetail destinationDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan'),
      ),
      body: SafeArea(child: SizedBox()),
      bottomSheet: Container(
        height: 80.h,
        width: 1.sw,
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
        child: WisataButton.primary(
          onPressed: () {},
          text: 'Lanjut ke Pembayaran',
        ),
      ),
    );
  }
}
