part of 'event_order_bloc.dart';

@freezed
class EventOrderState with _$EventOrderState {
  const factory EventOrderState({
    required bool isLoading,
    required List<Ticketable> tickets,
    required EventDetail? eventDetail,
    required List<Orderable> cart,
    required DateTime orderForDate,
    required bool isSubmitting,
    required Option<Either<Failure, Order>> createOrderOfFailureOption,
  }) = _EventOrderState;
  factory EventOrderState.initial() => EventOrderState(
        isLoading: false,
        tickets: [],
        eventDetail: null,
        cart: [],
        orderForDate: DateTime.now(),
        isSubmitting: false,
        createOrderOfFailureOption: none(),
      );
}
