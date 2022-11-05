part of 'destination_order_bloc.dart';

@freezed
class DestinationOrderEvent with _$DestinationOrderEvent {
  const factory DestinationOrderEvent.started() = _Started;
}