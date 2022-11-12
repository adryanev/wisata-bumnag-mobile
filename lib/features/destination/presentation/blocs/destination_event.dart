part of 'destination_bloc.dart';

@freezed
class DestinationEvent with _$DestinationEvent {
  const factory DestinationEvent.started({
    required Category? category,
  }) = _DestinationStarted;
}
