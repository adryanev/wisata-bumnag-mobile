import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_order/cart_order_bloc.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';
import 'package:wisatabumnag/shared/widgets/wisata_divider.dart';

class CartOrderPage extends StatelessWidget with FailureMessageHandler {
  const CartOrderPage({
    required this.cartSouvenir,
    super.key,
  });

  final CartSouvenir cartSouvenir;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CartOrderBloc>()
        ..add(
          CartOrderEvent.started(
            cartSouvenir,
          ),
        ),
      child: BlocListener<CartOrderBloc, CartOrderState>(
        listener: (context, state) {
          state.createOrderOfFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) {
                context
                    .read<CartBloc>()
                    .add(CartEvent.currentRemoved(cartSouvenir));
                Navigator.pop(context);

                context.pushNamed(AppRouter.payment, extra: r);
              },
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pesanan'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: Dimension.aroundPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Keranjang Suvenir',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColor.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
                            subtitle: Text(
                              '${e.quantity}x ${rupiahCurrency(e.price)}',
                            ),
                            trailing: Text(
                              '${rupiahCurrency(e.subtotal)}',
                              style: const TextStyle(
                                color: AppColor.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const WisataDivider(),
                  const PesananTanggalWidget(),
                  const WisataDivider(),
                  Padding(
                    padding: Dimension.aroundPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Rincian Biaya',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColor.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        ...cartSouvenir.items.map(
                          (e) => Column(
                            children: [
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      e.name,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${e.quantity}x',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      '${rupiahCurrency(e.price)}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      '${rupiahCurrency(e.subtotal)}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Harga',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Builder(
                              builder: (context) {
                                final total = cartSouvenir.items
                                    .map((e) => e.subtotal)
                                    .fold<double>(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element,
                                    );
                                return Text(
                                  '${rupiahCurrency(total)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            child: BlocBuilder<CartOrderBloc, CartOrderState>(
              builder: (context, state) {
                return WisataButton.primary(
                  onPressed: () {
                    showDialog<dynamic>(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<CartOrderBloc>(),
                        child: BlocBuilder<CartOrderBloc, CartOrderState>(
                          builder: (context, state) {
                            return ConfirmationDialog(
                              title: 'Konfirmasi Pesanan',
                              description: 'Apakah pesanan sudah benar? '
                                  'Jika sudah silahkan lanjut untuk melakukan '
                                  'pembayaran pesanan yang sudah dibuat.\n\n '
                                  'Item ini akan dihapus dari keranjang anda',
                              onDismiss: () {
                                Navigator.pop(context);
                              },
                              onConfirm: state.isSubmitting
                                  ? null
                                  : () {
                                      context.read<CartOrderBloc>().add(
                                            const CartOrderEvent
                                                .proceedToPaymentPressed(),
                                          );
                                    },
                              confirmText:
                                  state.isSubmitting ? 'Loading' : 'Lanjut',
                              dismissText: 'Batal',
                            );
                          },
                        ),
                      ),
                    );
                  },
                  text: 'Lanjut ke Pembayaran',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PesananTanggalWidget extends StatelessWidget {
  const PesananTanggalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tanggal',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          InkWell(
            onTap: () async {
              final bloc = context.read<CartOrderBloc>();
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 364),
                ),
              );
              log(date.toString());
              if (date != null) {
                bloc.add(CartOrderEvent.onOrderDateChanged(date));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.borderStroke,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: Dimension.aroundPadding,
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(
                      Icons.calendar_month,
                      color: AppColor.borderStroke,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child:
                        BlocSelector<CartOrderBloc, CartOrderState, DateTime>(
                      selector: (state) {
                        return state.orderDate;
                      },
                      builder: (context, state) {
                        return Text(
                          DateTimeFormat.completeDateWithDay.format(state),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
