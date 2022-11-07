import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_order/destination_order_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/souvenir_item_card.dart';
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
                    Divider(
                      thickness: 8.h,
                      color: AppColor.grey,
                    ),
                    SizedBox(
                      height: 100.h,
                    )
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
                        child: ElevatedButton(
                          onPressed: () {},
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
                      Text('1'),
                      SizedBox(
                        width: 8.w,
                      ),
                      SizedBox(
                        width: 25.w,
                        child: ElevatedButton(
                          onPressed: () {},
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
                return Text(
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
        ],
      ),
    );
  }
}
