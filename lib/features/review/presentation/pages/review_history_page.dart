import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/review/presentation/blocs/review_history/review_history_bloc.dart';
import 'package:wisatabumnag/features/review/presentation/widgets/review_list_item.dart';
import 'package:wisatabumnag/injector.dart';

class ReviewHistoryPage extends StatefulWidget {
  const ReviewHistoryPage({super.key});

  @override
  State<ReviewHistoryPage> createState() => _ReviewHistoryPageState();
}

class _ReviewHistoryPageState extends State<ReviewHistoryPage> {
  late final ReviewHistoryBloc _reviewHistoryBloc;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _reviewHistoryBloc = getIt<ReviewHistoryBloc>();
    _reviewHistoryBloc.add(const ReviewHistoryEvent.started());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _reviewHistoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reviewHistoryBloc,
      child: Padding(
        padding: Dimension.aroundPadding,
        child: BlocConsumer<ReviewHistoryBloc, ReviewHistoryState>(
          listener: (context, state) {
            switch (state.status) {
              case ReviewHistory.initial:
                break;
              case ReviewHistory.failure:
                state.isLoadMore
                    ? _refreshController.loadFailed()
                    : _refreshController.refreshFailed();
                break;
              case ReviewHistory.success:
                state.isLoadMore
                    ? _refreshController.loadComplete()
                    : _refreshController.refreshCompleted();
                break;
            }

            if (state.hasReachedMax) {
              _refreshController.loadNoData();
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case ReviewHistory.initial:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case ReviewHistory.failure:
                return const Center(
                  child: Text('failed to fetch Waiting for Review'),
                );
              case ReviewHistory.success:
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
                        .read<ReviewHistoryBloc>()
                        .add(const ReviewHistoryEvent.refreshed());
                  },
                  onLoading: () {
                    context
                        .read<ReviewHistoryBloc>()
                        .add(const ReviewHistoryEvent.started());
                  },
                  child: ListView.builder(
                    itemCount: state.orderDetails.length,
                    itemBuilder: (context, index) => ReviewListItem(
                      orderDetail: state.orderDetails[index],
                      isReviewed: true,
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
