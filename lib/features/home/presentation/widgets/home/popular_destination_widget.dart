import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            height: 190.h,
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
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return DestinationCard(
                      destination: state[index].destination,
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
