import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/currency_formatter.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class SouvenirDetailPage extends StatelessWidget {
  const SouvenirDetailPage({
    super.key,
    required this.destinationSouvenir,
    required this.souvenir,
  });
  final DestinationSouvenir destinationSouvenir;
  final Souvenir souvenir;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(souvenir.name.toTitleCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250.h,
              width: 1.sw,
              child: Swiper(
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: souvenir.media[index],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: souvenir.media.length,
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    activeColor: AppColor.primary,
                    size: 8.r,
                    activeSize: 10.r,
                    color: AppColor.secondBlack,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            // DestinationDetailHeaderWidget(
            //   destinationSouvenir: destinationSouvenir,
            // ),
            // Divider(
            //   thickness: 8.h,
            //   color: AppColor.grey,
            // ),
            // DestinationDetailContentWidget(
            //   destinationSouvenir: destinationSouvenir,
            // ),
            // Divider(
            //   thickness: 8.h,
            //   color: AppColor.grey,
            // ),
            // DestinationDetailLocationWidget(
            //   destinationSouvenir: destinationSouvenir,
            // ),
            // Divider(
            //   thickness: 8.h,
            //   color: AppColor.grey,
            // ),
            // DestinationDetailInformationWidget(
            //   destinationSouvenir: destinationSouvenir,
            // ),
            // Divider(
            //   thickness: 8.h,
            //   color: AppColor.grey,
            // ),
            // DestinationDetailReviewAndRecommendationWidget(
            //   destinationSouvenir: destinationSouvenir,
            // ),
            // SizedBox(
            //   height: 100.h,
            // )
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80.h,
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
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Harga mulai dari',
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 11.sp,
                    ),
                  ),
                  Text(
                    rupiahCurrency(
                          souvenir.price,
                        ) ??
                        '0',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 120.w,
              child: WisataButton.primary(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                        const AuthenticationEvent.checkAuthenticationStatus(),
                      );
                },
                text: 'Beli Tiket',
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class DestinationDetailHeaderWidget extends StatelessWidget {
//   const DestinationDetailHeaderWidget({
//     super.key,
//     required this.destinationSouvenir,
//   });
//   final DestinationDetail destinationSouvenir;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: Dimension.aroundPadding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             destinationSouvenir.name,
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w700,
//               color: AppColor.black,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(
//             height: 4.h,
//           ),
//           Text.rich(
//             TextSpan(
//               children: [
//                 WidgetSpan(
//                   alignment: PlaceholderAlignment.middle,
//                   child: Assets.icons.icLocationPin.svg(
//                     color: AppColor.primary,
//                     height: 14.h,
//                     width: 14.w,
//                   ),
//                 ),
//                 TextSpan(
//                   text: ' ${destinationSouvenir.address}',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: AppColor.secondBlack,
//                   ),
//                 ),
//               ],
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(
//             height: 6.h,
//           ),
//           Row(
//             children: [
//               if (destinationSouvenir.categories.firstWhereOrNull(
//                     (element) => element.id == 1 || element.parentId == 1,
//                   ) ==
//                   null) ...[
//                 if (destinationSouvenir.instagram == null)
//                   const SizedBox()
//                 else
//                   Flexible(
//                     flex: 6,
//                     child: Row(
//                       children: [
//                         Assets.icons.icInstagramSolid.svg(),
//                         SizedBox(
//                           width: 4.w,
//                         ),
//                         Text(
//                           destinationSouvenir.instagram!,
//                           style: const TextStyle(
//                             color: AppColor.darkGrey,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//               ] else ...[
//                 Flexible(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.star,
//                             color: const Color(0xFFFFB800),
//                             size: 24.r,
//                           ),
//                           SizedBox(
//                             width: 4.w,
//                           ),
//                           Text(
//                             '${destinationSouvenir.reviews.rating ?? 0}',
//                             style: TextStyle(
//                               color: AppColor.secondBlack,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 16.sp,
//                             ),
//                           )
//                         ],
//                       ),
//                       Text(
//                         '${destinationSouvenir.reviews.count} Review',
//                         style: const TextStyle(
//                           color: AppColor.darkGrey,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 25.h,
//                   width: 3.w,
//                   color: AppColor.grey,
//                 ),
//                 const Spacer(),
//                 if (destinationSouvenir.instagram == null)
//                   const SizedBox()
//                 else
//                   Flexible(
//                     flex: 6,
//                     child: Row(
//                       children: [
//                         Assets.icons.icInstagramSolid.svg(),
//                         SizedBox(
//                           width: 4.w,
//                         ),
//                         Text(
//                           destinationSouvenir.instagram!,
//                           style: const TextStyle(
//                             color: AppColor.darkGrey,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//               ]
//             ],
//           ),
//           SizedBox(
//             height: 20.h,
//           ),
//           Text(
//             'Jadwal Buka',
//             style: TextStyle(
//               color: AppColor.black,
//               fontWeight: FontWeight.w500,
//               fontSize: 16.sp,
//             ),
//           ),
//           Text(
//             '${destinationSouvenir.workingDay ?? '-'} '
//             '\u2022 ${destinationSouvenir.openingHours ?? "-"} - '
//             '${destinationSouvenir.closingHours ?? "-"}',
//             style: const TextStyle(
//               color: AppColor.darkGrey,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           SizedBox(
//             height: 16.h,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DestinationDetailContentWidget extends StatelessWidget {
//   const DestinationDetailContentWidget({
//     super.key,
//     required this.destinationSouvenir,
//   });
//   final DestinationDetail destinationSouvenir;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: Dimension.aroundPadding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Deskripsi',
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 16.sp,
//             ),
//           ),
//           SizedBox(
//             height: 8.h,
//           ),
//           Text(
//             destinationSouvenir.description,
//             style: TextStyle(
//               color: AppColor.secondBlack,
//               fontSize: 14.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DestinationDetailLocationWidget extends StatelessWidget {
//   const DestinationDetailLocationWidget({
//     super.key,
//     required this.destinationSouvenir,
//   });
//   final DestinationDetail destinationSouvenir;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: Dimension.aroundPadding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Lokasi',
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 16.sp,
//             ),
//           ),
//           SizedBox(
//             height: 8.h,
//           ),
//           Text(
//             destinationSouvenir.address,
//             style: TextStyle(
//               color: AppColor.secondBlack,
//               fontSize: 14.sp,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           if (destinationSouvenir.latitude == null ||
//               destinationSouvenir.longitude == null) ...[
//             const Text('Peta tidak tersedia'),
//           ] else ...[
//             SizedBox(
//               width: 1.sw,
//               height: 180.h,
//               child: DestinationGoogleMaps(
//                 latitude: destinationSouvenir.latitude!,
//                 longitude: destinationSouvenir.longitude!,
//               ),
//             ),
//             SizedBox(
//               height: 12.h,
//             ),
//             Center(
//               child: SizedBox(
//                 height: 35.h,
//                 width: 180.w,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     MapsLauncher.launchCoordinates(
//                       destinationSouvenir.latitude!,
//                       destinationSouvenir.longitude!,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: const StadiumBorder(),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Icon(
//                         Icons.near_me,
//                         size: 18.r,
//                       ),
//                       const Text('Petunjuk Arah'),
//                       Icon(
//                         Icons.navigate_next,
//                         size: 18.r,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ],
//       ),
//     );
//   }
// }

// class DestinationDetailInformationWidget extends StatelessWidget {
//   const DestinationDetailInformationWidget({
//     super.key,
//     required this.destinationSouvenir,
//   });
//   final DestinationDetail destinationSouvenir;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: Dimension.aroundPadding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Info Penting',
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 16.sp,
//             ),
//           ),
//           SizedBox(
//             height: 8.h,
//           ),
//           Text(
//             destinationSouvenir.description,
//             style: TextStyle(
//               color: AppColor.secondBlack,
//               fontSize: 14.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DestinationDetailReviewAndRecommendationWidget extends StatelessWidget {
//   const DestinationDetailReviewAndRecommendationWidget({
//     super.key,
//     required this.destinationSouvenir,
//   });
//   final DestinationDetail destinationSouvenir;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: Dimension.aroundPadding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Review',
//                 style: TextStyle(
//                   color: AppColor.black,
//                   fontSize: 16.sp,
//                 ),
//               ),
//               const Spacer(),
//               TextButton(onPressed: () {}, child: const Text('Lihat Semua'))
//             ],
//           ),
//           if (destinationSouvenir.reviews.count > 0) ...[
//             RichText(
//               text: TextSpan(
//                 style: const TextStyle(color: AppColor.black),
//                 children: [
//                   TextSpan(
//                     text: destinationSouvenir.reviews.rating.toString(),
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text: '/5',
//                     style: TextStyle(
//                       color: AppColor.darkGrey,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12.sp,
//                     ),
//                   ),
//                   WidgetSpan(
//                     child: SizedBox(
//                       width: 4.w,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Telah direview sebanyak '
//                         '${destinationSouvenir.reviews.count} kali.',
//                     style: TextStyle(
//                       color: AppColor.darkGrey,
//                       fontSize: 12.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 8.h,
//             ),
//             SizedBox(
//               width: 1.sw,
//               height: 120.h,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: destinationSouvenir.reviews.data.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   return ReviewableCard(
//                     review: destinationSouvenir.reviews.data[index],
//                   );
//                 },
//               ),
//             ),
//           ] else
//             const Text(
//               'Belum ada ulasan',
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 color: AppColor.darkGrey,
//               ),
//             ),
//           SizedBox(
//             height: 16.h,
//           ),
//           Text(
//             'Mungkin kamu suka',
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 16.sp,
//             ),
//           ),
//           SizedBox(
//             height: 16.h,
//           ),
//           SizedBox(
//             width: 1.sw,
//             height: 210.h,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: destinationSouvenir.recommendations.length,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     context.pushNamed(
//                       AppRouter.destinationSouvenir,
//                       queryParams: {
//                         'id': destinationSouvenir.recommendations[index].id
//                             .toString(),
//                       },
//                     );
//                   },
//                   child: (destinationSouvenir.categories.firstWhereOrNull(
//                             (element) =>
//                                 element.id == 1 || element.parentId == 1,
//                           ) ==
//                           null)
//                       ? DestinationNonTicketCard(
//                           destination:
//                               destinationSouvenir.recommendations[index],
//                         )
//                       : DestinationCard(
//                           destination:
//                               destinationSouvenir.recommendations[index],
//                         ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
