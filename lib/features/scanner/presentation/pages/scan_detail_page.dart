// ignore_for_file: lines_longer_than_80_chars

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
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/scanner/presentation/blocs/scan_detail/scan_detail_bloc.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';
import 'package:wisatabumnag/shared/widgets/wisata_divider.dart';

class ScanDetailPage extends StatelessWidget with FailureMessageHandler {
  const ScanDetailPage({super.key, required this.orderHistoryItem});
  final OrderHistoryItem orderHistoryItem;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScanDetailBloc>()
        ..add(ScanDetailEvent.started(orderHistoryItem)),
      child: BlocListener<ScanDetailBloc, ScanDetailState>(
        listener: (context, state) {
          state.approveTicketOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context.goNamed(AppRouter.scanSuccess, extra: true),
            ),
          );
          state.payTicketOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => Navigator.pop(context),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              orderHistoryItem.name,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderDetailHeaderWidget(orderHistoryItem: orderHistoryItem),
                  const WisataDivider(),
                  OrderDetailProdukWidget(orderHistoryItem: orderHistoryItem),
                  const WisataDivider(),
                  OrderDetailRincianPembayaran(
                    orderHistoryItem: orderHistoryItem,
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
            child: BlocBuilder<ScanDetailBloc, ScanDetailState>(
              builder: (context, state) {
                return state.isPaid
                    ? WisataButton.primary(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                showDialog<dynamic>(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<ScanDetailBloc>(),
                                    child: BlocBuilder<ScanDetailBloc,
                                        ScanDetailState>(
                                      builder: (context, state) {
                                        return ConfirmationDialog(
                                          title: 'Konfirmasi Setuju',
                                          description:
                                              'Apakah anda menyetujui tiket ini?',
                                          onDismiss: () {
                                            Navigator.pop(context);
                                          },
                                          onConfirm: state.isLoading
                                              ? null
                                              : () {
                                                  context
                                                      .read<ScanDetailBloc>()
                                                      .add(
                                                        const ScanDetailEvent
                                                            .approveButtonPressed(),
                                                      );
                                                },
                                          confirmText: state.isLoading
                                              ? 'Loading'
                                              : 'Setuju',
                                          dismissText: 'Batal',
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                        text: 'Setujui Tiket',
                      )
                    : WisataButton.primary(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                showDialog<dynamic>(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<ScanDetailBloc>(),
                                    child: BlocBuilder<ScanDetailBloc,
                                        ScanDetailState>(
                                      builder: (context, state) {
                                        return ConfirmationDialog(
                                          title: 'Konfirmasi Pembayaran',
                                          description:
                                              'Pastikan anda sudah menerima uang '
                                              'dari pengunjung',
                                          onDismiss: () {
                                            Navigator.pop(context);
                                          },
                                          onConfirm: state.isLoading
                                              ? null
                                              : () {
                                                  context
                                                      .read<ScanDetailBloc>()
                                                      .add(
                                                        const ScanDetailEvent
                                                            .payNowButtonPressed(),
                                                      );
                                                },
                                          confirmText: state.isLoading
                                              ? 'Loading'
                                              : 'Konfirmasi',
                                          dismissText: 'Batal',
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                        text: 'Bayar Tiket',
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OrderDetailHeaderWidget extends StatelessWidget {
  const OrderDetailHeaderWidget({super.key, required this.orderHistoryItem});
  final OrderHistoryItem orderHistoryItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailHeaderItem(
            title: 'Status Pesanan',
            value: OrderStatusMapper.toText(orderHistoryItem.order.status),
          ),
          SizedBox(
            height: 8.h,
          ),
          DetailHeaderItem(
            title: 'Kode Tagihan',
            value: orderHistoryItem.order.note,
          ),
          SizedBox(
            height: 8.h,
          ),
          DetailHeaderItem(
            title: 'Tanggal Tiket',
            value: DateTimeFormat.standard.format(
              orderHistoryItem.order.orderDate,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
        ],
      ),
    );
  }
}

class DetailHeaderItem extends StatelessWidget {
  const DetailHeaderItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColor.darkGrey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: AppColor.black),
        )
      ],
    );
  }
}

class OrderDetailProdukWidget extends StatelessWidget {
  const OrderDetailProdukWidget({super.key, required this.orderHistoryItem});
  final OrderHistoryItem orderHistoryItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Detail Produk',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          ListView.separated(
            separatorBuilder: (context, index) => const WisataDivider(),
            shrinkWrap: true,
            itemCount: orderHistoryItem.order.orderDetails.length,
            itemBuilder: (context, index) {
              final detail = orderHistoryItem.order.orderDetails[index];
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: detail.orderableType == r'App\Models\Ticket'
                        ? SizedBox(
                            height: 70.h,
                            width: 60.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: orderHistoryItem.media.isEmpty
                                  ? const SizedBox()
                                  : CachedNetworkImage(
                                      imageUrl: orderHistoryItem.media.first,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )
                        : SizedBox(
                            height: 70.h,
                            width: 60.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: detail.orderableDetail.media.isEmpty
                                  ? const SizedBox()
                                  : CachedNetworkImage(
                                      imageUrl:
                                          detail.orderableDetail.media.first,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                    title: Text(
                      detail.orderableName,
                    ),
                    subtitle: Text(
                      '${detail.quantity} x '
                      '${rupiahCurrency(detail.orderablePrice)}',
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(
                          color: AppColor.darkGrey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${rupiahCurrency(detail.subtotal)}',
                        style: const TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class OrderDetailRincianPembayaran extends StatelessWidget {
  const OrderDetailRincianPembayaran({
    super.key,
    required this.orderHistoryItem,
  });
  final OrderHistoryItem orderHistoryItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Rincian Pembayaran',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          DetailHeaderItem(
            title: 'Metode Pembayaran',
            value: orderHistoryItem.order.paymentType == null
                ? ''
                : PaymentTypeMapper.toText(
                    orderHistoryItem.order.paymentType!,
                  ),
          ),
          SizedBox(
            height: 8.h,
          ),
          DetailHeaderItem(
            title: 'Total Harga '
                '(${orderHistoryItem.order.orderDetails.map((e) => e.quantity).fold<int>(
                      0,
                      (previousValue, element) => previousValue + element,
                    )} item)',
            value: '${rupiahCurrency(orderHistoryItem.order.totalPrice)}',
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            children: [
              const Text(
                'Total Keseluruhan',
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${rupiahCurrency(orderHistoryItem.order.totalPrice)}',
                style: const TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
