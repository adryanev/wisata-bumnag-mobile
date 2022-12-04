import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:wisatabumnag/injector.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with FailureMessageHandler {
  late NotificationBloc _notificationBloc;
  late RefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _notificationBloc = getIt<NotificationBloc>();
    _refreshController = RefreshController();
    _notificationBloc.add(const NotificationEvent.started());
  }

  @override
  void dispose() {
    _notificationBloc.close();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _notificationBloc,
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          state.notificationOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) {
                handleFailure(context, l);
                state.isLoadMore
                    ? _refreshController.loadFailed()
                    : _refreshController.refreshFailed();
              },
              (r) {
                state.isLoadMore
                    ? _refreshController.loadComplete()
                    : _refreshController.refreshCompleted();
              },
            ),
          );

          if (state.hasReachedMax) {
            _refreshController.loadNoData();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notification'),
            actions: [
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: state.notifications.firstWhereOrNull(
                              (element) => !element.isRead,
                            ) !=
                            null
                        ? () {
                            context.read<NotificationBloc>().add(
                                  const NotificationEvent
                                      .readAllButtonPressed(),
                                );
                          }
                        : null,
                    icon: const Tooltip(
                      message: 'Baca semua notifikasi',
                      child: Icon(
                        Icons.remove_red_eye_rounded,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  return Tooltip(
                    message: 'Hapus semua notifikasi',
                    child: IconButton(
                      onPressed: state.notifications.isEmpty
                          ? null
                          : () {
                              context.read<NotificationBloc>().add(
                                    const NotificationEvent
                                        .deleteAllButtonPressed(),
                                  );
                            },
                      icon: const Icon(Icons.delete_forever_rounded),
                    ),
                  );
                },
              )
            ],
          ),
          body: SafeArea(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state.isRefreshing) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
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
                        .read<NotificationBloc>()
                        .add(const NotificationEvent.refreshed());
                  },
                  onLoading: () {
                    if (state.hasReachedMax) return;
                    context
                        .read<NotificationBloc>()
                        .add(const NotificationEvent.started());
                  },
                  child: ListView.builder(
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        context.read<NotificationBloc>().add(
                              NotificationEvent.notificationClicked(
                                index: index,
                                id: state.notifications[index].id,
                              ),
                            );
                      },
                      child: ListTile(
                        leading: state.notifications[index].isRead
                            ? null
                            : const Icon(
                                Icons.noise_control_off,
                                color: AppColor.primary,
                              ),
                        title: Text(state.notifications[index].data.title),
                        subtitle: Text(state.notifications[index].data.body),
                        trailing: Text(
                          DateTimeFormat.completeDateWithTime.format(
                            state.notifications[index].createdAt,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
