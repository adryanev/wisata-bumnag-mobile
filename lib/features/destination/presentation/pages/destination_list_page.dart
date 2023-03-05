import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_bloc.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_result/destination_result_bloc.dart';
import 'package:wisatabumnag/features/destination/presentation/widgets/destination_result_list.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/widgets/custom_tab_view.dart';

class DestinationListPage extends StatefulWidget {
  const DestinationListPage({
    required this.category,
    super.key,
  });
  final Category? category;

  @override
  State<DestinationListPage> createState() => _DestinationListPageState();
}

class _DestinationListPageState extends State<DestinationListPage>
    with FailureMessageHandler {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DestinationBloc>()
        ..add(
          DestinationEvent.started(
            category: widget.category,
          ),
        ),
      child: BlocListener<DestinationBloc, DestinationState>(
        listener: (context, state) {
          state.categoriesOrFailureOption.fold(
            () => null,
            (either) =>
                either.fold((l) => handleFailure(context, l), (r) => null),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('${widget.category?.name.toTitleCase()}'),
          ),
          body: SafeArea(
            child: Padding(
              padding: Dimension.aroundPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<DestinationBloc, DestinationState>(
                    builder: (context, state) {
                      if (state.isCategoryLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      if (state.categories != null) {
                        final categories = [
                          widget.category!.copyWith(name: 'Semua'),
                          ...state.categories!,
                        ];
                        return CustomTabView(
                          itemCount: categories.length,
                          tabBuilder: (context, index) {
                            return Tab(text: categories[index].name);
                          },
                          pageBuilder: (context, index) {
                            // return SizedBox();
                            return BlocProvider(
                              key: Key('destination_result_bloc_$index'),
                              create: (_) => getIt<DestinationResultBloc>(),
                              child: DestinationResultList(
                                key: Key('destination_result_list_$index'),
                                category: categories[index],
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
