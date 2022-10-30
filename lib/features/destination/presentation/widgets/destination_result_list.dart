import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_result/destination_result_bloc.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/widgets/destination_card.dart';

class DestinationResultList extends StatefulWidget {
  const DestinationResultList({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  State<DestinationResultList> createState() => _DestinationResultListState();
}

class _DestinationResultListState extends State<DestinationResultList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context
        .read<DestinationResultBloc>()
        .add(DestinationResultEvent.fetched(widget.category));
  }

  void _onScroll() {
    if (_isBottom) {
      context
          .read<DestinationResultBloc>()
          .add(DestinationResultEvent.fetched(widget.category));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DestinationResultBloc, DestinationResultState>(
      builder: (context, state) {
        switch (state.status) {
          case DestinationResultStatus.initial:
            return const Center(child: CircularProgressIndicator.adaptive());

          case DestinationResultStatus.success:
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => DestinationCard(
                destination: state.destinations[index],
              ),
              itemCount: state.destinations.length,
              controller: _scrollController,
            );
          case DestinationResultStatus.failure:
            return const Center(child: Text('failed to fetch Destination'));
        }
      },
    );
  }
}
