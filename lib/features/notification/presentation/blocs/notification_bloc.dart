import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/notification/domain/entities/notification.entity.dart';
import 'package:wisatabumnag/features/notification/domain/usecases/delete_notifications.dart';
import 'package:wisatabumnag/features/notification/domain/usecases/get_notifications_pagination.dart';
import 'package:wisatabumnag/features/notification/domain/usecases/read_all_notification.dart';
import 'package:wisatabumnag/features/notification/domain/usecases/read_notification.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';

part 'notification_event.dart';
part 'notification_state.dart';
part 'notification_bloc.freezed.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(
    this._getNotificationPagination,
    this._readNotification,
    this._readAllNotification,
    this._deleteNotifications,
  ) : super(NotificationState.initial()) {
    on<_NotificationStarted>(_onStarted);
    on<_NotificationClicked>(_onClicked);
    on<_NotificationReadAllPressed>(_onReadAll);
    on<_NotificationDeleteAllPressed>(_onDelete);
    on<_NotificationRefreshed>(_onRefresh);
  }

  final GetNotificationPagination _getNotificationPagination;
  final ReadNotification _readNotification;
  final ReadAllNotification _readAllNotification;
  final DeleteNotifications _deleteNotifications;

  FutureOr<void> _onStarted(
    _NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.hasReachedMax) return emit(state.copyWith());
    if (state.notifications.isEmpty) {
      emit(state.copyWith(isRefreshing: true));
      final result = await _getNotificationPagination(
        const GetNotificationPaginationParams(),
      );
      if (result.isRight()) {
        final notifications = result.getRight();

        emit(
          state.copyWith(
            notifications: notifications!.data,
            pagination: notifications.pagination,
            hasReachedMax: notifications.pagination.lastPage ==
                state.pagination.currentPage,
          ),
        );
      }
      emit(
        state.copyWith(
          notificationOrFailureOption: optionOf(result),
        ),
      );
      return emit(
        state.copyWith(
          isRefreshing: false,
          notificationOrFailureOption: none(),
        ),
      );
    }

    emit(state.copyWith(isLoadMore: true));

    final result = await _getNotificationPagination(
      GetNotificationPaginationParams(
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final notifications = result.getRight();
      emit(
        state.copyWith(
          notifications: List.of(state.notifications)
            ..addAll(
              notifications!.data,
            ),
          pagination: notifications.pagination,
          hasReachedMax:
              notifications.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    emit(
      state.copyWith(
        notificationOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        notificationOrFailureOption: none(),
        isLoadMore: false,
      ),
    );
  }

  FutureOr<void> _onClicked(
    _NotificationClicked event,
    Emitter<NotificationState> emit,
  ) async {
    final result =
        await _readNotification(ReadNotificationParams(id: event.id));
    final temp = [...state.notifications];
    final notification = temp[event.index];
    final read = notification.copyWith(isRead: true);
    temp[event.index] = read;
    emit(
      state.copyWith(
        readNotificationOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        readNotificationOrFailureOption: none(),
        notifications: [...temp],
      ),
    );
  }

  FutureOr<void> _onReadAll(
    _NotificationReadAllPressed event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _readAllNotification(NoParams());
    emit(
      state.copyWith(
        readAllOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        readAllOrFailureOption: none(),
        notifications: [...state.notifications]
            .map((e) => e.copyWith(isRead: true))
            .toList(),
      ),
    );
  }

  FutureOr<void> _onDelete(
    _NotificationDeleteAllPressed event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _deleteNotifications(NoParams());

    emit(
      state.copyWith(
        deleteOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        deleteOrFailureOption: none(),
        notifications: [...state.notifications]..clear(),
      ),
    );
  }

  FutureOr<void> _onRefresh(
    _NotificationRefreshed event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationState.initial());
    add(const NotificationEvent.started());
  }
}
