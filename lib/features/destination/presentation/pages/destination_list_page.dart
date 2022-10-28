import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/features/destination/presentation/blocs/destination_bloc.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/widgets/filter_widget.dart';
import 'package:wisatabumnag/shared/widgets/search_widget.dart';

class DestinationListPage extends StatefulWidget {
  const DestinationListPage({super.key, required this.category});
  final Category? category;

  @override
  State<DestinationListPage> createState() => _DestinationListPageState();
}

class _DestinationListPageState extends State<DestinationListPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category?.name.toTitleCase()}'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Column(
            children: [
              Row(
                children: [
                  SearchWidget(
                    controller: searchEditingController,
                  ),
                  Spacer(),
                  FilterWidget(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
