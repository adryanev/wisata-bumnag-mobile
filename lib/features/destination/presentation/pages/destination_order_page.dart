// ignore_for_file: lines_longer_than_80_chars

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_order/destination_order_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';
import 'package:wisatabumnag/shared/widgets/souvenir_item_card.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class DestinationOrder extends StatelessWidget with FailureMessageHandler {
  const DestinationOrder({
    super.key,
    required this.destinationDetail,
  });
  final DestinationDetail destinationDetail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DestinationOrderBloc>()
        ..add(
          DestinationOrderEvent.started(
            destinationDetail,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan'),
        ),
        body: BlocListener<DestinationOrderBloc, DestinationOrderState>(
          listener: (context, state) {
            state.souvenirsOrFailureOption.fold(
              () => null,
              (either) => either.fold(
                (l) => handleFailure(context, l),
                (r) => null,
              ),
            );

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
            child: BlocBuilder<DestinationOrderBloc, DestinationOrderState>(
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
                      DetailPesananWidget(destinationDetail: destinationDetail),
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
                      const DetailPesananSouvenirWidget(),
                      Divider(
                        thickness: 8.h,
                        color: AppColor.grey,
                      ),
                      const DetailPesananSouvenirCartWidget(),
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
          child: BlocBuilder<DestinationOrderBloc, DestinationOrderState>(
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
                              context.read<DestinationOrderBloc>().add(
                                    const DestinationOrderEvent
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
  const DetailPesananWidget({super.key, required this.destinationDetail});
  final DestinationDetail destinationDetail;
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
            destinationDetail.name,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 14.sp,
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Assets.icons.icLocationPin.svg(
                    color: AppColor.primary,
                    height: 14.h,
                    width: 14.w,
                  ),
                ),
                TextSpan(
                  text: ' ${destinationDetail.address}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColor.secondBlack,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
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
              final bloc = context.read<DestinationOrderBloc>();
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
                bloc.add(DestinationOrderEvent.orderForDateChanged(date));
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
                    child: BlocSelector<DestinationOrderBloc,
                        DestinationOrderState, DateTime>(
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
          BlocBuilder<DestinationOrderBloc, DestinationOrderState>(
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
                                        context
                                            .read<DestinationOrderBloc>()
                                            .add(
                                              DestinationOrderEvent
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
                                  context.read<DestinationOrderBloc>().add(
                                        DestinationOrderEvent
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

class DetailPesananSouvenirWidget extends StatelessWidget {
  const DetailPesananSouvenirWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Souvenir',
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const Text(
            'Berwisata gak lengkap rasanya kalau belum belanja suvenir. '
            'Tambahkan suvenir yang kamu sukai.',
            style: TextStyle(
              color: AppColor.darkGrey,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          BlocBuilder<DestinationOrderBloc, DestinationOrderState>(
            builder: (context, state) {
              if (state.souvenirs.isEmpty) {
                return const Text(
                  'Sepertinya destinasi ini tidak ada souvenir.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColor.darkGrey,
                  ),
                );
              }
              return SizedBox(
                height: 220.h,
                width: 1.sw,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.souvenirs.length,
                  itemBuilder: (context, index) {
                    return SouvenirItemCard(
                      souvenir: state.souvenirs[index],
                      onAddToCart: () {
                        context.read<DestinationOrderBloc>().add(
                              DestinationOrderEvent
                                  .souvenirAddCartButtonPressed(
                                state.souvenirs[index],
                              ),
                            );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailPesananSouvenirCartWidget extends StatelessWidget {
  const DetailPesananSouvenirCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Keranjang Souvenir',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            height: 12.w,
          ),
          BlocBuilder<DestinationOrderBloc, DestinationOrderState>(
            builder: (context, state) {
              final list = state.cart
                  .where((element) => element.type == OrderableType.souvenir);
              if (list.isEmpty) {
                return Text(
                  'Kamu belum memilih souvenir.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                    color: AppColor.darkGrey,
                  ),
                );
              }
              return Column(
                children: [
                  ...list
                      .map(
                        (e) => ListTile(
                          leading: e.media == null
                              ? null
                              : CachedNetworkImage(imageUrl: e.media!),
                          title: Text(e.name),
                          subtitle: Text('${rupiahCurrency(e.price)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24.w,
                                child: IconButton(
                                  onPressed: () {
                                    context.read<DestinationOrderBloc>().add(
                                          DestinationOrderEvent
                                              .souvenirCartDeleteButtonPressed(
                                            e,
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
                                          context
                                              .read<DestinationOrderBloc>()
                                              .add(
                                                DestinationOrderEvent
                                                    .souvenirCartRemoveButtonPressed(
                                                  e,
                                                ),
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
                              Text('${e.quantity}'),
                              SizedBox(
                                width: 8.w,
                              ),
                              SizedBox(
                                width: 24.w,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<DestinationOrderBloc>().add(
                                          DestinationOrderEvent
                                              .souvenirCartAddButtonPressed(e),
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
                        ),
                      )
                      .toList()
                ],
              );
            },
          )
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
          BlocBuilder<DestinationOrderBloc, DestinationOrderState>(
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
                      BlocBuilder<DestinationOrderBloc, DestinationOrderState>(
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
