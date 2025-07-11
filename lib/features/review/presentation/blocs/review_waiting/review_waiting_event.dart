part of 'review_waiting_bloc.dart';

@freezed
abstract class ReviewWaitingEvent with _$ReviewWaitingEvent {
  const factory ReviewWaitingEvent.started() = _ReviewWaitingStarted;
  const factory ReviewWaitingEvent.refreshed() = _ReviewWaitingRefreshed;
}
