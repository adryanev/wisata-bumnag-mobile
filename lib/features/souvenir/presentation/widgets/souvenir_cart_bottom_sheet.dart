import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class SouvenirCartBottomSheet extends StatelessWidget {
  SouvenirCartBottomSheet({
    required this.souvenir,
    super.key,
  });
  final Souvenir souvenir;
  final ValueNotifier<int> counter = ValueNotifier(1);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: .25.sh,
      padding: Dimension.aroundPadding,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tambahkan Produk',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: souvenir.media.isEmpty
                ? const SizedBox()
                : CachedNetworkImage(imageUrl: souvenir.media.first),
            title: Text(souvenir.name.toTitleCase()),
            subtitle: Text('${rupiahCurrency(souvenir.price)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24.w,
                  child: ValueListenableBuilder(
                    valueListenable: counter,
                    builder: (context, value, widget) => ElevatedButton(
                      onPressed: value == 1
                          ? null
                          : () {
                              counter.value -= 1;
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: AppColor.primary,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.remove),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                ValueListenableBuilder(
                  valueListenable: counter,
                  builder: (context, value, widget) {
                    return Text('$value');
                  },
                ),
                SizedBox(
                  width: 8.w,
                ),
                SizedBox(
                  width: 24.w,
                  child: ElevatedButton(
                    onPressed: () {
                      counter.value += 1;
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColor.primary,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          Align(
            child: SizedBox(
              child: WisataButton.primary(
                onPressed: () {
                  Navigator.pop(context, counter.value);
                },
                text: 'Simpan ke keranjang',
              ),
            ),
          )
        ],
      ),
    );
  }
}
