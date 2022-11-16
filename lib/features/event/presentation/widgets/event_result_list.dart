import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/features/event/presentation/blocs/event_list/event_list_bloc.dart';
import 'package:wisatabumnag/features/event/presentation/widgets/event_card.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

class EventResultList extends StatefulWidget {
  const EventResultList({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  State<EventResultList> createState() => _EventResultListState();
}

class _EventResultListState extends State<EventResultList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<EventListBloc>().add(const EventListEvent.started());
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<EventListBloc>().add(const EventListEvent.started());
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventListBloc, EventListState>(
      builder: (context, state) {
        switch (state.status) {
          case EventListStatus.initial:
            return const Center(child: CircularProgressIndicator.adaptive());

          case EventListStatus.success:
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  context.pushNamed(
                    AppRouter.eventDetail,
                    queryParams: {
                      'id': state.events[index].id.toString(),
                    },
                  );
                },
                child: EventCard(
                  event: state.events[index],
                ),
              ),
              itemCount: state.events.length,
              controller: _scrollController,
            );
          case EventListStatus.failure:
            return const Center(child: Text('failed to fetch Destination'));
        }
      },
    );
  }
}
