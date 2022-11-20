part of 'cart_order_bloc.dart';

@freezed
class CartOrderState with _$CartOrderState {
  const factory CartOrderState({
    required CartSouvenir? cartSouvenir,
    required Option<Either<Failure, Order>> createOrderOfFailureOption,
    required DateTime orderDate,
    required bool isSubmitting,
    required bool isLoading,
  }) = _CartOrderState;
  factory CartOrderState.initial() => CartOrderState(
        cartSouvenir: null,
        createOrderOfFailureOption: none(),
        isSubmitting: false,
        isLoading: false,
        orderDate: DateTime.now(),
      );
}
