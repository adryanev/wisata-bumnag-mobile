import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_payment/destination_payment_bloc.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';
import 'package:wisatabumnag/shared/widgets/wisata_divider.dart';

class DestinationPaymentPage extends StatelessWidget {
  const DestinationPaymentPage({
    super.key,
    required this.order,
  });
  final Order order;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DestinationPaymentBloc>()
        ..add(DestinationPaymentEvent.started(order)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pembayaran',
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SelectPaymentMethodWidget(),
              const WisataDivider(),
              RincianBiayaWidget(
                order: order,
              ),
            ],
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
          child: BlocBuilder<DestinationPaymentBloc, DestinationPaymentState>(
            builder: (context, state) {
              return WisataButton.primary(
                onPressed: () {},
                text: 'Bayar',
              );
            },
          ),
        ),
      ),
    );
  }
}

class SelectPaymentMethodWidget extends StatelessWidget {
  const SelectPaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimension.aroundPadding,
      child: BlocBuilder<DestinationPaymentBloc, DestinationPaymentState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 12.w,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.borderStroke,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: RadioListTile<PaymentType>(
                  value: PaymentType.onsite,
                  groupValue: state.paymentType,
                  title: const Text('Bayar di tempat'),
                  onChanged: (type) {
                    context.read<DestinationPaymentBloc>().add(
                          DestinationPaymentEvent.onPaymentTypeChanged(type!),
                        );
                  },
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.borderStroke,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: RadioListTile<PaymentType>(
                  value: PaymentType.online,
                  groupValue: state.paymentType,
                  title: const Text('Bayar Online'),
                  subtitle: const Text('via ATM, QRIS, E-Wallet'),
                  onChanged: (type) {
                    context.read<DestinationPaymentBloc>().add(
                          DestinationPaymentEvent.onPaymentTypeChanged(type!),
                        );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RincianBiayaWidget extends StatelessWidget {
  const RincianBiayaWidget({super.key, required this.order});
  final Order order;
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
          ...order.orderDetails
              .map(
                (e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        e.orderableName,
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
                        '${rupiahCurrency(e.orderablePrice)}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${rupiahCurrency(e.subtotal)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          SizedBox(
            height: 12.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${rupiahCurrency(order.totalPrice)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
