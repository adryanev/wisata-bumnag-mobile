import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late final ScrollController _scrollController;
  late final OrderListBloc _orderListBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _orderListBloc = getIt<OrderListBloc>();
    _orderListBloc.add(const OrderListEvent.started());
  }

  void _onScroll() {
    if (_isBottom) {
      _orderListBloc.add(const OrderListEvent.started());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _orderListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _orderListBloc,
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
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: AppColor.grey,
                        indent: 16.w,
                        endIndent: 16.w,
                        thickness: 2.h,
                      ),
                      itemCount: state.orderHistories.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: OrderListItem(
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
    );
  }
}
