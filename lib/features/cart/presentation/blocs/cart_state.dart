part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    required Pair<DestinationSouvenir, Souvenir>? temporary,
    required List<CartSouvenir> cartSouvenir,
    required Option<Either<Failure, Unit>> cartSavedOrFailureOption,
    required Option<Either<Failure, List<CartSouvenir>>>
        cartSouvenirOrFailureOption,
    required List<CartSouvenir> selectedCartSouvenir,
    required double totalPrice,
    required CartStatus status,
  }) = _CartState;
  factory CartState.initial() => CartState(
        temporary: null,
        cartSavedOrFailureOption: none(),
        cartSouvenir: [],
        selectedCartSouvenir: [],
        totalPrice: 0,
        cartSouvenirOrFailureOption: none(),
        status: CartStatus.initial,
      );
}

enum CartStatus {
  initial,
  fetching,
  saving,
  temporary,
}
