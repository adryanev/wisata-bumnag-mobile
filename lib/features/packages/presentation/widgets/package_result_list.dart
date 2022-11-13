import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context
        .read<PackageListBloc>()
        .add(PackageListEvent.started(widget.category));
  }

  void _onScroll() {
    if (_isBottom) {
      context
          .read<PackageListBloc>()
          .add(PackageListEvent.started(widget.category));
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
    return BlocBuilder<PackageListBloc, PackageListState>(
      builder: (context, state) {
        switch (state.status) {
          case PackageListStatus.initial:
            return const Center(child: CircularProgressIndicator.adaptive());

          case PackageListStatus.success:
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  context.pushNamed(
                    AppRouter.destinationDetail,
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
              controller: _scrollController,
            );
          case PackageListStatus.failure:
            return const Center(child: Text('failed to fetch Destination'));
        }
      },
    );
  }
}
