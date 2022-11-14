// ignore_for_file: lines_longer_than_80_chars

import 'dart:developer';
import 'package:collection/collection.dart';
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
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/features/packages/presentation/blocs/package_order/package_order_bloc.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class PackageOrderPage extends StatelessWidget with FailureMessageHandler {
  const PackageOrderPage({
    super.key,
    required this.packageDetail,
  });
  final PackageDetail packageDetail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PackageOrderBloc>()
        ..add(
          PackageOrderEvent.started(
            packageDetail,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan'),
        ),
        body: BlocListener<PackageOrderBloc, PackageOrderState>(
          listener: (context, state) {
            state.createOrderOfFailureOption.fold(
              () => null,
              (either) => either.fold(
                (l) => handleFailure(context, l),
                (r) {
                  Navigator.pop(context);

                  context.pushNamed(AppRouter.payment, extra: r);
                },
              ),
            );
          },
          child: SafeArea(
            child: BlocBuilder<PackageOrderBloc, PackageOrderState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DetailPesananWidget(packageDetail: packageDetail),
                      Divider(
                        thickness: 8.h,
                        color: AppColor.grey,
                      ),
                      const DetailPesananTanggalWidget(),
                      Divider(
                        thickness: 8.h,
                        color: AppColor.grey,
                      ),
                      const DetailPesananTicketWidget(),
                      Divider(
                        thickness: 8.h,
                        color: AppColor.grey,
                      ),
                      const DetailPesananRincianBiayaWidget(),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  ),
                );
              },
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
          child: BlocBuilder<PackageOrderBloc, PackageOrderState>(
            builder: (context, state) {
              return WisataButton.primary(
                onPressed: state.cart.isEmpty
                    ? null
                    : () {
                        showDialog<dynamic>(
                          context: context,
                          builder: (_) => ConfirmationDialog(
                            title: 'Konfirmasi Pesanan',
                            description: 'Apakah pesanan sudah benar? '
                                'Jika sudah silahkan lanjut untuk melakukan '
                                'pembayaran pesanan yang sudah dibuat',
                            onDismiss: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                              context.read<PackageOrderBloc>().add(
                                    const PackageOrderEvent
                                        .proceedToPaymentButtonPressed(),
                                  );
                            },
                            confirmText: 'Lanjut',
                            dismissText: 'Batal',
                          ),
                        );
                      },
                text: 'Lanjut ke Pembayaran',
              );
            },
          ),
        ),
      ),
    );
  }
}

class DetailPesananWidget extends StatelessWidget {
  const DetailPesananWidget({super.key, required this.packageDetail});
  final PackageDetail packageDetail;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Detail Pesanan',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            height: 12.w,
          ),
          Text(
            packageDetail.name,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPesananTanggalWidget extends StatelessWidget {
  const DetailPesananTanggalWidget({super.key});

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
              final bloc = context.read<PackageOrderBloc>();
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
                bloc.add(PackageOrderEvent.orderForDateChanged(date));
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
                    child: BlocSelector<PackageOrderBloc, PackageOrderState,
                        DateTime>(
                      selector: (state) {
                        return state.orderForDate;
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

class DetailPesananTicketWidget extends StatelessWidget {
  const DetailPesananTicketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tiket',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          BlocBuilder<PackageOrderBloc, PackageOrderState>(
            builder: (context, state) {
              return Column(
                children: [
                  ...state.tickets.map(
                    (e) {
                      final currentTicketsInCart = state.cart.firstWhereOrNull(
                        (element) =>
                            element.id == e.id &&
                            element.type == OrderableType.ticket,
                      );
                      final quantity = currentTicketsInCart?.quantity ?? 0;
                      return ListTile(
                        title: Text(e.name),
                        subtitle: Text('${rupiahCurrency(e.price)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 25.w,
                              child: ElevatedButton(
                                onPressed: quantity == 0
                                    ? null
                                    : () {
                                        context.read<PackageOrderBloc>().add(
                                              PackageOrderEvent
                                                  .ticketRemoveButtonPressed(e),
                                            );
                                      },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: AppColor.primary,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(Icons.remove),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text('$quantity'),
                            SizedBox(
                              width: 8.w,
                            ),
                            SizedBox(
                              width: 25.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<PackageOrderBloc>().add(
                                        PackageOrderEvent
                                            .ticketAddButtonPressed(e),
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: AppColor.primary,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList()
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailPesananRincianBiayaWidget extends StatelessWidget {
  const DetailPesananRincianBiayaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Rincian Biaya',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            height: 12.w,
          ),
          BlocBuilder<PackageOrderBloc, PackageOrderState>(
            builder: (context, state) {
              if (state.cart.isEmpty) {
                return Text(
                  'Keranjang kamu masih kosong',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                    color: AppColor.darkGrey,
                  ),
                );
              }
              return Column(
                children: [
                  ...state.cart
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      )
                      .toList(),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      BlocBuilder<PackageOrderBloc, PackageOrderState>(
                        builder: (context, state) {
                          final total =
                              state.cart.map((e) => e.subtotal).fold<double>(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element,
                                  );
                          return Text(
                            '${rupiahCurrency(total)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
