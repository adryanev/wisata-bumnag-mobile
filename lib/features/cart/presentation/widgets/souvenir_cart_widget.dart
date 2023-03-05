import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class SouvenirCartWidget extends StatelessWidget {
  const SouvenirCartWidget({
    required this.cartSouvenir,
    super.key,
  });
  final CartSouvenir cartSouvenir;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Padding(
          padding: Dimension.aroundPadding,
          child: SizedBox(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Assets.icons.icStore.svg(
                            color: AppColor.darkGrey,
                            height: 18.h,
                            width: 18.w,
                          ),
                        ),
                        TextSpan(
                          text: ' ${cartSouvenir.destinationName}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    cartSouvenir.destinationAddress ?? '',
                    style: TextStyle(
                      color: AppColor.darkGrey,
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing: WisataButton.primary(
                    onPressed: () {
                      context.pushNamed(
                        AppRouter.cartOrder,
                        extra: cartSouvenir,
                      );
                    },
                    text: 'Bayar',
                  ),
                ),
                ...cartSouvenir.items.map(
                  (e) => ListTile(
                    leading: e.media == null
                        ? null
                        : SizedBox(
                            height: 60.h,
                            width: 60.w,
                            child: CachedNetworkImage(
                              imageUrl: e.media!,
                              fit: BoxFit.cover,
                            ),
                          ),
                    title: Text(e.name),
                    subtitle: Text('${rupiahCurrency(e.price)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24.w,
                          child: IconButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    CartEvent.deleteButtonPressed(
                                      destinationSouvenir: cartSouvenir,
                                      orderable: e,
                                    ),
                                  );
                            },
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SizedBox(
                          width: 24.w,
                          child: ElevatedButton(
                            onPressed: e.quantity == 1
                                ? null
                                : () {
                                    context.read<CartBloc>().add(
                                          CartEvent.removeButtonPressed(
                                            destinationSouvenir: cartSouvenir,
                                            orderable: e,
                                          ),
                                        );
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
                        SizedBox(
                          width: 8.w,
                        ),
                        Text('${e.quantity}'),
                        SizedBox(
                          width: 8.w,
                        ),
                        SizedBox(
                          width: 24.w,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    CartEvent.addButtonPressed(
                                      destinationSouvenir: cartSouvenir,
                                      orderable: e,
                                    ),
                                  );
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
