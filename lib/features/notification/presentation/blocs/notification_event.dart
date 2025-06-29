part of 'notification_bloc.dart';

@freezed
abstract class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent.started() = _NotificationStarted;
  const factory NotificationEvent.refreshed() = _NotificationRefreshed;
  const factory NotificationEvent.notificationClicked({
    required int index,
    required String id,
  }) = _NotificationClicked;
  const factory NotificationEvent.readAllButtonPressed() =
      _NotificationReadAllPressed;
  const factory NotificationEvent.deleteAllButtonPressed() =
      _NotificationDeleteAllPressed;
}
