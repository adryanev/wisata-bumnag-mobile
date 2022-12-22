import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/review/presentation/blocs/review_waiting/review_waiting_bloc.dart';
import 'package:wisatabumnag/features/review/presentation/widgets/review_list_item.dart';
import 'package:wisatabumnag/injector.dart';

class ReviewWaitingPage extends StatefulWidget {
  const ReviewWaitingPage({super.key});

  @override
  State<ReviewWaitingPage> createState() => _ReviewWaitingPageState();
}

class _ReviewWaitingPageState extends State<ReviewWaitingPage> {
  late final ReviewWaitingBloc _reviewWaitingBloc;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _reviewWaitingBloc = getIt<ReviewWaitingBloc>();
    _reviewWaitingBloc.add(const ReviewWaitingEvent.started());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _reviewWaitingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reviewWaitingBloc,
      child: Padding(
        padding: Dimension.aroundPadding,
        child: BlocConsumer<ReviewWaitingBloc, ReviewWaitingState>(
          listener: (context, state) {
            switch (state.status) {
              case ReviewWaiting.initial:
                break;
              case ReviewWaiting.failure:
                state.isLoadMore
                    ? _refreshController.loadFailed()
                    : _refreshController.refreshFailed();
                break;
              case ReviewWaiting.success:
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
              case ReviewWaiting.initial:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case ReviewWaiting.failure:
                return const Center(
                  child: Text('failed to fetch Waiting for Review'),
                );
              case ReviewWaiting.success:
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
                        .read<ReviewWaitingBloc>()
                        .add(const ReviewWaitingEvent.refreshed());
                  },
                  onLoading: () {
                    context
                        .read<ReviewWaitingBloc>()
                        .add(const ReviewWaitingEvent.started());
                  },
                  child: ListView.builder(
                    itemCount: state.orderDetails.length,
                    itemBuilder: (context, index) => ReviewListItem(
                      orderDetail: state.orderDetails[index],
                      isReviewed: false,
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
