part of 'event_order_bloc.dart';

@freezed
class EventOrderEvent with _$EventOrderEvent {
  const factory EventOrderEvent.started(
    EventDetail eventDetail,
  ) = _EventOrderStarted;
  const factory EventOrderEvent.orderForDateChanged(DateTime dateTime) =
      _EventOrderForDateChanged;
  const factory EventOrderEvent.ticketAddButtonPressed(
    Ticketable ticketable,
  ) = _EventOrderTicketAddButtonPressed;

  const factory EventOrderEvent.ticketRemoveButtonPressed(
    Ticketable ticketable,
  ) = _EventOrderTicketRemoveButtonPressed;

  const factory EventOrderEvent.proceedToPaymentButtonPressed() =
      _EventOrderProceedToPaymentButtonPressed;
}
