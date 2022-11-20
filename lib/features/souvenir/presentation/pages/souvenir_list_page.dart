import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:wisatabumnag/features/souvenir/presentation/blocs/souvenir_list_bloc.dart';
import 'package:wisatabumnag/features/souvenir/presentation/widgets/destination_souvenir_card.dart';
import 'package:wisatabumnag/features/souvenir/presentation/widgets/souvenir_cart_bottom_sheet.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/confirmation_dialog.dart';

class SouvenirListPage extends StatefulWidget {
  const SouvenirListPage({super.key});

  @override
  State<SouvenirListPage> createState() => _SouvenirListPageState();
}

class _SouvenirListPageState extends State<SouvenirListPage>
    with FailureMessageHandler {
  late SouvenirListBloc _souvenirListBloc;

  late final ScrollController _scrollController;
  final ValueNotifier<bool> showBottomSheet = ValueNotifier(true);

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
      child: MultiBlocListener(
        listeners: [
          BlocListener<SouvenirListBloc, SouvenirListState>(
            listener: (context, state) {
              state.souvenirsPaginationOrFailureOption.fold(
                () => null,
                (either) => either.fold(
                  (l) => handleFailure(context, l),
                  (r) => null,
                ),
              );
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (_) async {
                  final cartBloc = context.read<CartBloc>();
                  if (showBottomSheet.value) {
                    showBottomSheet.value = false;

                    final bottomSheet = await showModalBottomSheet<int>(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(
                            20.r,
                          ),
                        ),
                      ),
                      context: context,
                      builder: (_) {
                        return BlocProvider.value(
                          value: cartBloc,
                          child: SouvenirCartBottomSheet(
                            souvenir: cartBloc.state.temporary!.second,
                          ),
                        );
                      },
                    );
                    log('BottomSheet value = $bottomSheet');
                    if (bottomSheet != null) {
                      cartBloc.add(
                        CartEvent.souvenirAddButtonPressed(
                          quantity: bottomSheet,
                          destinationSouvenir: cartBloc.state.temporary!.first,
                          souvenir: cartBloc.state.temporary!.second,
                        ),
                      );
                    }
                    showBottomSheet.value = true;
                  }
                },
                unauthenticated: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => ConfirmationDialog(
                      title: 'Harus Masuk',
                      description: 'Untuk memesan item ini anda harus masuk '
                          'terlebih dahulu.',
                      confirmText: 'Masuk',
                      dismissText: 'Batal',
                      onDismiss: () {
                        Navigator.pop(context);
                      },
                      onConfirm: () {
                        context.pushNamed(AppRouter.login);
                      },
                    ),
                  );
                },
                failed: (l) => handleFailure(context, l),
                orElse: () => null,
              );
            },
          ),
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state.temporary != null &&
                  state.status == CartStatus.temporary) {
                context
                    .read<AuthenticationBloc>()
                    .add(const AuthenticationEvent.checkAuthenticationStatus());
              }
            },
          )
        ],
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
