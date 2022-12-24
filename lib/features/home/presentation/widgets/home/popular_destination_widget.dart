import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/home/domain/entities/recommendation.entity.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/home_front/cubit/home_front_cubit.dart';
import 'package:wisatabumnag/shared/widgets/destination_card.dart';

class PopularDestinationWidget extends StatelessWidget {
  const PopularDestinationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Destinasi Populer',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          SizedBox(
            height: 220.h,
            width: 1.sw,
            child: BlocSelector<HomeFrontCubit, HomeFrontState,
                List<Recommendation>?>(
              selector: (state) {
                return state.recommendations;
              },
              builder: (context, state) {
                if (state == null) {
                  return const SizedBox();
                }
                if (state.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada rekomendasi',
                      style: TextStyle(
                        color: AppColor.darkGrey,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
                final filteredRecommendation = state
                    .where((element) => element.destination != null)
                    .toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredRecommendation.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.pushNamed(
                          AppRouter.destinationDetail,
                          queryParams: {
                            'id': filteredRecommendation[index]
                                .destination!
                                .id
                                .toString(),
                          },
                        );
                      },
                      child: DestinationCard(
                        destination: filteredRecommendation[index].destination!,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
