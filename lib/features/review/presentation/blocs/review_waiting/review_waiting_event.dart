part of 'review_waiting_bloc.dart';

@freezed
class ReviewWaitingEvent with _$ReviewWaitingEvent {
  const factory ReviewWaitingEvent.started() = _ReviewWaitingStarted;
}
