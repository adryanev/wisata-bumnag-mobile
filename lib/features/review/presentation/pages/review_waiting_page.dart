import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final ScrollController _scrollController;
  late final ReviewWaitingBloc _reviewWaitingBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _reviewWaitingBloc = getIt<ReviewWaitingBloc>();
    _reviewWaitingBloc.add(const ReviewWaitingEvent.started());
  }

  void _onScroll() {
    if (_isBottom) {
      _reviewWaitingBloc.add(const ReviewWaitingEvent.started());
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
    _reviewWaitingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reviewWaitingBloc,
      child: Padding(
        padding: Dimension.aroundPadding,
        child: BlocBuilder<ReviewWaitingBloc, ReviewWaitingState>(
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
                return ListView.builder(
                  itemCount: state.orderDetails.length,
                  itemBuilder: (context, index) => ReviewListItem(
                    orderDetail: state.orderDetails[index],
                    isReviewed: false,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
