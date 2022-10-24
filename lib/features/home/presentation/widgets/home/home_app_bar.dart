import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/l10n/l10n.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        YourLocationWidget(),
        Spacer(
          flex: 10,
        ),
        HomeCartWidget(),
        Spacer(),
        HomeNotificationWidget(),
      ],
    );
  }
}

class HomeNotificationWidget extends StatelessWidget {
  const HomeNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.icons.icNotificationActive.svg();
  }
}

class HomeCartWidget extends StatelessWidget {
  const HomeCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.icons.icCartActive.svg();
  }
}

class YourLocationWidget extends StatelessWidget {
  const YourLocationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.yourLocation,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10.sp,
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 2.w,
          children: [
            Assets.icons.icLocationPin.svg(),
            Text(
              'Pesisir Selatan, Sumatera Barat',
              style: TextStyle(
                fontSize: 11.sp,
              ),
            )
          ],
        )
      ],
    );
  }
}
