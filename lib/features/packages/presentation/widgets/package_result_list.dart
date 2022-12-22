import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/packages/presentation/blocs/package_list/package_list_bloc.dart';
import 'package:wisatabumnag/features/packages/presentation/widgets/package_card.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

class PackageResultList extends StatefulWidget {
  const PackageResultList({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  State<PackageResultList> createState() => _PackageResultListState();
}

class _PackageResultListState extends State<PackageResultList> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
    context
        .read<PackageListBloc>()
        .add(PackageListEvent.started(widget.category));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackageListBloc, PackageListState>(
      listener: (context, state) {
        switch (state.status) {
          case PackageListStatus.initial:
            break;
          case PackageListStatus.failure:
            state.isLoadMore
                ? _refreshController.loadFailed()
                : _refreshController.refreshFailed();
            break;
          case PackageListStatus.success:
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
          case PackageListStatus.initial:
            return const Center(child: CircularProgressIndicator.adaptive());

          case PackageListStatus.success:
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
                    .read<PackageListBloc>()
                    .add(PackageListEvent.refreshed(widget.category));
              },
              onLoading: () {
                context
                    .read<PackageListBloc>()
                    .add(PackageListEvent.started(widget.category));
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
                      AppRouter.packageDetail,
                      queryParams: {
                        'id': state.packages[index].id.toString(),
                      },
                    );
                  },
                  child: PackageCard(
                    package: state.packages[index],
                  ),
                ),
                itemCount: state.packages.length,
              ),
            );
          case PackageListStatus.failure:
            return const Center(child: Text('failed to fetch Destination'));
        }
      },
    );
  }
}
