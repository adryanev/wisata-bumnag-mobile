// ignore_for_file: lines_longer_than_80_chars

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';
import 'package:wisatabumnag/shared/widgets/wisata_divider.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderHistoryItem});
  final OrderHistoryItem orderHistoryItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              OrderDetailRincianPembayaran(orderHistoryItem: orderHistoryItem),
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
        child: orderHistoryItem.order.paymentType == null
            ? WisataButton.primary(
                onPressed: () {
                  showDialog<dynamic>(
                    context: context,
                    builder: (_) => ConfirmationDialog(
                      title: 'Konfirmasi Pesanan',
                      description: 'Apakah pesanan sudah benar? '
                          'Jika sudah silahkan lanjut untuk melakukan '
                          'pembayaran pesanan yang sudah dibuat.',
                      onDismiss: () {
                        Navigator.pop(context);
                      },
                      onConfirm: () {
                        context.pushNamed(
                          AppRouter.payment,
                          extra: orderHistoryItem.order,
                        );
                      },
                      confirmText: 'Lanjut',
                      dismissText: 'Batal',
                    ),
                  );
                },
                text: 'Lanjut ke Pembayaran',
              )
            : orderHistoryItem.order.qrCode == null
                ? const SizedBox()
                : WisataButton.primary(
                    onPressed: () {
                      showDialog<dynamic>(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: Dimension.aroundPadding,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    orderHistoryItem.name.toTitleCase(),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  SizedBox(
                                    height: .2.sh,
                                    width: .4.sw,
                                    child: SvgPicture.network(
                                      orderHistoryItem.order.qrCode!,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Text(
                                    'Tiket siap digunakan',
                                    style: TextStyle(
                                      color: AppColor.darkGrey,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  const Text(
                                    'Tunjukkan QR ini kepada petugas tiket '
                                    'yang berjaga di objek wisata.',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  SizedBox(
                                    width: .4.sh,
                                    height: 40.h,
                                    child: WisataButton.primary(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'Kembali',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    text: 'Lihat Tiket',
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
                              child: CachedNetworkImage(
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
                              child: CachedNetworkImage(
                                imageUrl: detail.orderableDetail.media.first,
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
