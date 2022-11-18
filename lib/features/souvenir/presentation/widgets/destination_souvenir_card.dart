import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/shared/widgets/souvenir_item_card.dart';

class DestinationSouvenirCard extends StatelessWidget {
  const DestinationSouvenirCard({
    super.key,
    required this.destinationSouvenir,
  });
  final DestinationSouvenir destinationSouvenir;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.softGrey,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: Dimension.aroundPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              destinationSouvenir.name,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Assets.icons.icLocationPin
                        .svg(color: AppColor.darkGrey),
                  ),
                  TextSpan(
                    text: ' ${destinationSouvenir.address}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.darkGrey,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: destinationSouvenir.souvenirs.length,
                itemBuilder: (context, index) => SouvenirItemCard(
                  souvenir: destinationSouvenir.souvenirs[index],
                  onTap: () {
                    context.pushNamed(
                      AppRouter.souvenirDetail,
                      extra: {
                        'souvenir': destinationSouvenir.souvenirs[index],
                        'destinationSouvenir': destinationSouvenir,
                      },
                    );
                  },
                  onAddToCart: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
