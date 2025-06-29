part of 'cart_order_bloc.dart';

@freezed
abstract class CartOrderEvent with _$CartOrderEvent {
  const factory CartOrderEvent.started(CartSouvenir cart) = _CartOrderStarted;
  const factory CartOrderEvent.proceedToPaymentPressed() =
      _CartOrderProceedToPaymentPressed;

  const factory CartOrderEvent.onOrderDateChanged(DateTime date) =
      _CartOrderDateChanged;
}
