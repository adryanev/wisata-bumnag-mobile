import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class SouvenirItemCard extends StatelessWidget {
  const SouvenirItemCard({
    super.key,
    required this.souvenir,
    required this.onAddToCart,
    this.onTap,
  });
  final Souvenir souvenir;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.w,
      width: 140.w,
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 110.h,
                width: 1.sw,
                child: CachedNetworkImage(
                  imageUrl: souvenir.media.first,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      souvenir.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFFFB800),
                          size: 12.r,
                        ),
                        Text(
                          ' ${souvenir.reviews.rating ?? 0}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColor.darkGrey,
                          ),
                        ),
                        Text(
                          '(${souvenir.reviews.count})',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${rupiahCurrency(
                          souvenir.price,
                        )}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          color: AppColor.secondBlack,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 25.w,
                      child: WisataButton.primary(
                        onPressed: onAddToCart,
                        text: '+ Keranjang',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
