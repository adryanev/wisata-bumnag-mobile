import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/order_list/order_list_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/order_history/order_item_list.dart';
import 'package:wisatabumnag/injector.dart';

class HomeHistoryOrderPage extends StatelessWidget {
  const HomeHistoryOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OrderListBloc>()..add(const OrderListEvent.started()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Pesanan'),
        ),
        body: SafeArea(
          child: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: BlocBuilder<OrderListBloc, OrderListState>(
              builder: (context, state) {
                switch (state.status) {
                  case OrderListStatus.initial:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case OrderListStatus.failure:
                    return const Center(
                      child: Text('failed to fetch Order Histories'),
                    );
                  case OrderListStatus.success:
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: AppColor.grey,
                        indent: 16.w,
                        endIndent: 16.w,
                        thickness: 2.h,
                      ),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: OrderListItem(
                          order: state.orders[index],
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
