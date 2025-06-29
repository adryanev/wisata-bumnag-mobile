part of 'package_order_bloc.dart';

@freezed
abstract class PackageOrderEvent with _$PackageOrderEvent {
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

  const factory PackageOrderEvent.amenitiesIncreaseButtonPressed(
    Amenity amenity,
  ) = _PackageOrderAmenitiesIncreaseButtonPressed;

  const factory PackageOrderEvent.amenitiesDecreaseButtonPressed(
    Amenity amenity,
  ) = _PackageOrderAmenitiesDecreaseButtonPressed;

  const factory PackageOrderEvent.proceedToPaymentButtonPressed() =
      _PackageOrderProceedToPaymentButtonPressed;
}
