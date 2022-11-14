part of 'destination_detail_bloc.dart';

@freezed
class DestinationDetailEvent with _$DestinationDetailEvent {
  const factory DestinationDetailEvent.started(String? destinationId) =
      _DestinationDetailStarted;
}
