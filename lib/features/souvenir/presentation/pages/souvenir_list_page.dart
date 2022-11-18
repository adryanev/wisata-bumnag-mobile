import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/souvenir/presentation/blocs/souvenir_list_bloc.dart';
import 'package:wisatabumnag/features/souvenir/presentation/widgets/destination_souvenir_card.dart';
import 'package:wisatabumnag/injector.dart';

class SouvenirListPage extends StatefulWidget {
  const SouvenirListPage({super.key});

  @override
  State<SouvenirListPage> createState() => _SouvenirListPageState();
}

class _SouvenirListPageState extends State<SouvenirListPage>
    with FailureMessageHandler {
  late SouvenirListBloc _souvenirListBloc;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _souvenirListBloc = getIt<SouvenirListBloc>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _souvenirListBloc.add(const SouvenirListEvent.started());
  }

  void _onScroll() {
    if (_isBottom) {
      _souvenirListBloc.add(const SouvenirListEvent.started());
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
    _souvenirListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _souvenirListBloc
        ..add(
          const SouvenirListEvent.started(),
        ),
      child: BlocListener<SouvenirListBloc, SouvenirListState>(
        listener: (context, state) {
          state.souvenirsPaginationOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Suvenir'),
          ),
          body: SafeArea(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColor.grey,
              ),
              child: BlocBuilder<SouvenirListBloc, SouvenirListState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SouvenirListStatus.initial:
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    case SouvenirListStatus.failure:
                      return const Center(
                        child: Text('Failed to fetch Souvenirs'),
                      );
                    case SouvenirListStatus.success:
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.souvenirs.length,
                        itemBuilder: (context, index) =>
                            DestinationSouvenirCard(
                          destinationSouvenir: state.souvenirs[index],
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
