import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/home/presentation/blocs/order_list/order_list_bloc.dart';
import 'package:wisatabumnag/features/home/presentation/widgets/order_history/order_item_list.dart';
import 'package:wisatabumnag/injector.dart';

class HomeHistoryOrderPage extends StatefulWidget {
  const HomeHistoryOrderPage({super.key});

  @override
  State<HomeHistoryOrderPage> createState() => _HomeHistoryOrderPageState();
}

class _HomeHistoryOrderPageState extends State<HomeHistoryOrderPage> {
  late final OrderListBloc _orderListBloc;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _orderListBloc = getIt<OrderListBloc>();
    _orderListBloc.add(const OrderListEvent.started());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _orderListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxWidth: 1.sw,
      child: BlocProvider(
        create: (context) => _orderListBloc,
        child: BlocListener<OrderListBloc, OrderListState>(
          listener: (context, state) {
            switch (state.status) {
              case OrderListStatus.initial:
                break;
              case OrderListStatus.failure:
                state.isLoadMore
                    ? _refreshController.loadFailed()
                    : _refreshController.refreshFailed();
                break;
              case OrderListStatus.success:
                state.isLoadMore
                    ? _refreshController.loadComplete()
                    : _refreshController.refreshCompleted();
                break;
            }

            if (state.hasReachedMax) {
              _refreshController.loadNoData();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Riwayat Transaksi'),
            ),
            body: SafeArea(
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: BlocBuilder<OrderListBloc, OrderListState>(
                  bloc: _orderListBloc,
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
                        return SmartRefresher(
                          controller: _refreshController,
                          enablePullUp: true,
                          header: const WaterDropHeader(
                            waterDropColor: AppColor.primary,
                          ),
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                          ),
                          onRefresh: () {
                            context
                                .read<OrderListBloc>()
                                .add(const OrderListEvent.refreshed());
                          },
                          onLoading: () {
                            if (state.hasReachedMax) return;
                            context
                                .read<OrderListBloc>()
                                .add(const OrderListEvent.started());
                          },
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: AppColor.grey,
                              indent: 16.w,
                              endIndent: 16.w,
                              thickness: 2.h,
                            ),
                            itemCount: state.orderHistories.length,
                            itemBuilder: (context, index) => OrderListItem(
                              order: state.orderHistories[index],
                            ),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
