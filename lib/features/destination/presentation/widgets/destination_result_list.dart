import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_result/destination_result_bloc.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/widgets/destination_card.dart';
import 'package:wisatabumnag/shared/widgets/destination_non_ticket_card.dart';

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
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    context
        .read<DestinationResultBloc>()
        .add(DestinationResultEvent.fetched(widget.category));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DestinationResultBloc, DestinationResultState>(
      listener: (context, state) {
        switch (state.status) {
          case DestinationResultStatus.initial:
            // _refreshController.refreshToIdle();
            break;
          case DestinationResultStatus.success:
            state.isLoadMore
                ? _refreshController.loadComplete()
                : _refreshController.refreshCompleted();
            break;
          case DestinationResultStatus.failure:
            state.isLoadMore
                ? _refreshController.loadFailed()
                : _refreshController.refreshFailed();
            break;
        }

        if (state.hasReachedMax) {
          _refreshController.loadNoData();
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case DestinationResultStatus.initial:
            return const Center(child: CircularProgressIndicator.adaptive());

          case DestinationResultStatus.success:
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
                    .read<DestinationResultBloc>()
                    .add(DestinationResultEvent.refreshed(widget.category));
              },
              onLoading: () {
                if (state.hasReachedMax) return;
                context
                    .read<DestinationResultBloc>()
                    .add(DestinationResultEvent.fetched(widget.category));
              },
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    context.pushNamed(
                      AppRouter.destinationDetail,
                      queryParams: {
                        'id': state.destinations[index].id.toString(),
                      },
                    );
                  },
                  child:
                      (widget.category.id == 1 || widget.category.parentId == 1)
                          ? DestinationCard(
                              destination: state.destinations[index],
                            )
                          : DestinationNonTicketCard(
                              destination: state.destinations[index],
                            ),
                ),
                itemCount: state.destinations.length,
                // controller: _scrollController,
              ),
            );
          case DestinationResultStatus.failure:
            return const Center(child: Text('failed to fetch Destination'));
        }
      },
    );
  }
}
