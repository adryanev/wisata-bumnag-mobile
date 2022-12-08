part of 'payment_bloc.dart';

@freezed
class PaymentEvent with _$PaymentEvent {
  const factory PaymentEvent.started(Order order) = _PaymentStarted;
  const factory PaymentEvent.onPayButtonPressed() = _PaymentPayButtonPressed;
}
