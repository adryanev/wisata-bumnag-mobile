import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final ScrollController _scrollController;
  late final ReviewHistoryBloc _reviewHistoryBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _reviewHistoryBloc = getIt<ReviewHistoryBloc>();
    _reviewHistoryBloc.add(const ReviewHistoryEvent.started());
  }

  void _onScroll() {
    if (_isBottom) {
      _reviewHistoryBloc.add(const ReviewHistoryEvent.started());
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
    _reviewHistoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reviewHistoryBloc,
      child: Padding(
        padding: Dimension.aroundPadding,
        child: BlocBuilder<ReviewHistoryBloc, ReviewHistoryState>(
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
                return ListView.builder(
                  itemCount: state.orderDetails.length,
                  itemBuilder: (context, index) => ReviewListItem(
                    orderDetail: state.orderDetails[index],
                    isReviewed: true,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
