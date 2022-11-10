part of 'destination_payment_bloc.dart';

@freezed
class DestinationPaymentEvent with _$DestinationPaymentEvent {
  const factory DestinationPaymentEvent.started(Order order) =
      _DestinationPaymentStarted;
  const factory DestinationPaymentEvent.onPaymentTypeChanged(
    PaymentType paymentType,
  ) = _DestinationPaymentTypeChanged;

  const factory DestinationPaymentEvent.onPayButtonPressed() =
      _DestinationPaymentPayButtonPressed;
}
