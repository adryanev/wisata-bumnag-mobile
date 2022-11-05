part of 'destination_order_bloc.dart';

@freezed
class DestinationOrderState with _$DestinationOrderState {
  const factory DestinationOrderState({
    required bool isLoading,
    required List<Ticketable>? tickets,
    required DestinationDetail? destinationDetail,
  }) = _DestinationOrderState;
  factory DestinationOrderState.initial() => DestinationOrderState(
        isLoading: false,
        tickets: null,
        destinationDetail: null,
      );
}
