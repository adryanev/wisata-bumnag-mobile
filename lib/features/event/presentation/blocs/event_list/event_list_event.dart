part of 'event_list_bloc.dart';

@freezed
abstract class EventListEvent with _$EventListEvent {
  const factory EventListEvent.started() = _EventListStarted;
  const factory EventListEvent.refreshed() = _EventListRefreshed;
}
