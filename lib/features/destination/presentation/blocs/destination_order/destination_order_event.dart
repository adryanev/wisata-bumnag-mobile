part of 'destination_order_bloc.dart';

@freezed
class DestinationOrderEvent with _$DestinationOrderEvent {
  const factory DestinationOrderEvent.started(
    DestinationDetail destinationDetail,
  ) = _DestinationOrderStarted;
  const factory DestinationOrderEvent.orderForDateChanged(DateTime dateTime) =
      _DestinationOrderForDateChanged;
}
