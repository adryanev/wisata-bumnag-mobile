import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_order/destination_order_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class DestinationOrder extends StatelessWidget {
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
        body: SafeArea(
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
                    const DetailPesananTanggal(),
                    Divider(
                      thickness: 8.h,
                      color: AppColor.grey,
                    ),
                    const DetailPesananTicket(),
                    Divider(
                      thickness: 8.h,
                      color: AppColor.grey,
                    ),
                  ],
                ),
              );
            },
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
          child: WisataButton.primary(
            onPressed: () {},
            text: 'Lanjut ke Pembayaran',
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

class DetailPesananTanggal extends StatelessWidget {
  const DetailPesananTanggal({super.key});

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
          Container(
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
          )
        ],
      ),
    );
  }
}

class DetailPesananTicket extends StatelessWidget {
  const DetailPesananTicket({super.key});

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
          ...[1, 2, 3, 4]
              .map(
                (e) => ListTile(
                  title: Text('Anak-anak'),
                  subtitle: Text('Rp15.000'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 25.w,
                          child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.remove),
                              label: SizedBox())),
                      Text('1'),
                      SizedBox(
                          width: 25.w,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add),
                            color: AppColor.primary,
                          )),
                    ],
                  ),
                ),
              )
              .toList()
          // Flexible(
          //   child: ListView(
          //     children: [
          //       ListTile(
          //         title: Text('Anak-anak'),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
