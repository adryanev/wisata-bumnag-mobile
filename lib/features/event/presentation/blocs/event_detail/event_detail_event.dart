part of 'event_detail_bloc.dart';

@freezed
abstract class EventDetailEvent with _$EventDetailEvent {
  const factory EventDetailEvent.started(String? eventId) = _EventDetailStarted;
}
