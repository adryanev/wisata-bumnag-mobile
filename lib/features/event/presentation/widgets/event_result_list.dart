import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/event/presentation/blocs/event_list/event_list_bloc.dart';
import 'package:wisatabumnag/features/event/presentation/widgets/event_card.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

class EventResultList extends StatefulWidget {
  const EventResultList({
    required this.category,
    super.key,
  });
  final Category category;

  @override
  State<EventResultList> createState() => _EventResultListState();
}

class _EventResultListState extends State<EventResultList> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    context.read<EventListBloc>().add(const EventListEvent.started());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventListBloc, EventListState>(
      listener: (context, state) {
        switch (state.status) {
          case EventListStatus.initial:
            break;
          case EventListStatus.failure:
            state.isLoadMore
                ? _refreshController.loadFailed()
                : _refreshController.refreshFailed();
            break;
          case EventListStatus.success:
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
          case EventListStatus.initial:
            return const Center(child: CircularProgressIndicator.adaptive());

          case EventListStatus.success:
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
                    .read<EventListBloc>()
                    .add(const EventListEvent.refreshed());
              },
              onLoading: () {
                context
                    .read<EventListBloc>()
                    .add(const EventListEvent.started());
              },
              child: AlignedGridView.custom(
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    context.pushNamed(
                      AppRouter.eventDetail,
                      queryParameters: {
                        'id': state.events[index].id.toString(),
                      },
                    );
                  },
                  child: EventCard(
                    event: state.events[index],
                  ),
                ),
                itemCount: state.events.length,
              ),
            );
          case EventListStatus.failure:
            return const Center(child: Text('failed to fetch Events'));
        }
      },
    );
  }
}
