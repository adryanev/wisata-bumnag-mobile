import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_bloc.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_result/destination_result_bloc.dart';
import 'package:wisatabumnag/features/packages/presentation/widgets/package_result_list.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/widgets/custom_tab_view.dart';
// import 'package:wisatabumnag/shared/widgets/filter_widget.dart';
// import 'package:wisatabumnag/shared/widgets/search_widget.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({super.key, required this.category});
  final Category? category;

  @override
  State<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage>
    with FailureMessageHandler {
  late final TextEditingController searchEditingController;
  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController()
      ..addListener(() {
        context
            .read<DestinationBloc>()
            .add(DestinationEvent.started(category: widget.category));
      });
  }

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
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row(
                    //   children: [
                    //     SearchWidget(
                    //       controller: searchEditingController,
                    //     ),
                    //     Spacer(),
                    //     FilterWidget(),
                    //   ],
                    // ),
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
                                child: PackageResultList(
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
      ),
    );
  }
}
