part of 'package_order_bloc.dart';

@freezed
class PackageOrderEvent with _$PackageOrderEvent {
  const factory PackageOrderEvent.started(
    PackageDetail packageDetail,
  ) = _PackageOrderStarted;
  const factory PackageOrderEvent.orderForDateChanged(DateTime dateTime) =
      _PackageOrderForDateChanged;
  const factory PackageOrderEvent.ticketAddButtonPressed(
    Ticketable ticketable,
  ) = _PackageOrderTicketAddButtonPressed;

  const factory PackageOrderEvent.ticketRemoveButtonPressed(
    Ticketable ticketable,
  ) = _PackageOrderTicketRemoveButtonPressed;

  const factory PackageOrderEvent.proceedToPaymentButtonPressed() =
      _PackageOrderProceedToPaymentButtonPressed;
}
