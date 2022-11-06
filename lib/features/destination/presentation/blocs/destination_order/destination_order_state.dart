part of 'destination_order_bloc.dart';

@freezed
class DestinationOrderState with _$DestinationOrderState {
  const factory DestinationOrderState({
    required bool isLoading,
    required List<Ticketable> tickets,
    required DestinationDetail? destinationDetail,
    required Option<Either<Failure, List<Souvenir>>> souvenirsOrFailureOption,
    required List<Souvenir> souvenirs,
    required List<Orderable> cart,
    required DateTime orderForDate,
  }) = _DestinationOrderState;
  factory DestinationOrderState.initial() => DestinationOrderState(
        isLoading: false,
        tickets: [],
        destinationDetail: null,
        souvenirsOrFailureOption: none(),
        souvenirs: [],
        cart: [],
        orderForDate: DateTime.now(),
      );
}
