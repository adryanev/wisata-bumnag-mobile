part of 'notification_bloc.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    required bool isRefreshing,
    required bool isLoadMore,
    required Option<Either<Failure, Paginable<Notification>>>
        notificationOrFailureOption,
    required List<Notification> notifications,
    required Option<Either<Failure, Unit>> readNotificationOrFailureOption,
    required Option<Either<Failure, Unit>> readAllOrFailureOption,
    required Option<Either<Failure, Unit>> deleteOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
  }) = _NotificationState;
  factory NotificationState.initial() => NotificationState(
        isRefreshing: false,
        isLoadMore: false,
        notificationOrFailureOption: none(),
        notifications: [],
        readNotificationOrFailureOption: none(),
        readAllOrFailureOption: none(),
        deleteOrFailureOption: none(),
        hasReachedMax: false,
        currentPage: 1,
        pagination: const Pagination(
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: 0,
        ),
      );
}
