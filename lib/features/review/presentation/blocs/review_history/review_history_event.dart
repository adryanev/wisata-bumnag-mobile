part of 'review_history_bloc.dart';

@freezed
abstract class ReviewHistoryEvent with _$ReviewHistoryEvent {
  const factory ReviewHistoryEvent.started() = _ReviewHistoryStarted;
  const factory ReviewHistoryEvent.refreshed() = _ReviewHistoryRefreshed;
}
