part of 'explore_bloc.dart';

@freezed
abstract class ExploreEvent with _$ExploreEvent {
  const factory ExploreEvent.started() = _ExploreStarted;
  const factory ExploreEvent.refreshed() = _ExploreRefreshed;
}
