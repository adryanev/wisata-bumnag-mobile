part of 'destination_order_bloc.dart';

@freezed
abstract class DestinationOrderEvent with _$DestinationOrderEvent {
  const factory DestinationOrderEvent.started(
    DestinationDetail destinationDetail,
  ) = _DestinationOrderStarted;
  const factory DestinationOrderEvent.orderForDateChanged(DateTime dateTime) =
      _DestinationOrderForDateChanged;
  const factory DestinationOrderEvent.ticketAddButtonPressed(
    Ticketable ticketable,
  ) = _DestinationOrderTicketAddButtonPressed;

  const factory DestinationOrderEvent.ticketRemoveButtonPressed(
    Ticketable ticketable,
  ) = _DestinationOrderTicketRemoveButtonPressed;
  const factory DestinationOrderEvent.souvenirAddCartButtonPressed(
    Souvenir souvenir,
  ) = _DestinationOrderSouvenirAddCartButtonPressed;
  const factory DestinationOrderEvent.souvenirCartAddButtonPressed(
    Orderable souvenir,
  ) = _DestinationOrderSouvenirCartAddButtonPressed;
  const factory DestinationOrderEvent.souvenirCartRemoveButtonPressed(
    Orderable souvenir,
  ) = _DestinationOrderSouvenirCartRemoveButtonPressed;

  const factory DestinationOrderEvent.souvenirCartDeleteButtonPressed(
    Orderable souvenir,
  ) = _DestinationOrderSouvenirCartDeleteButtonPressed;

  const factory DestinationOrderEvent.proceedToPaymentButtonPressed() =
      _DestinationOrderProceedToPaymentButtonPressed;
}
