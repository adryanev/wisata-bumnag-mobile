part of 'destination_detail_bloc.dart';

@freezed
abstract class DestinationDetailEvent with _$DestinationDetailEvent {
  const factory DestinationDetailEvent.started(String? destinationId) =
      _DestinationDetailStarted;
}
