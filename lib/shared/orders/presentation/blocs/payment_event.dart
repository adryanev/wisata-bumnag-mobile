part of 'payment_bloc.dart';

@freezed
sealed class PaymentEvent with _$PaymentEvent {
  const factory PaymentEvent.started(UserOrder order) = _PaymentStarted;
  const factory PaymentEvent.onPayButtonPressed() = _PaymentPayButtonPressed;
}
