part of 'review_history_bloc.dart';

@freezed
class ReviewHistoryEvent with _$ReviewHistoryEvent {
  const factory ReviewHistoryEvent.started() = _ReviewHistoryStarted;
}
