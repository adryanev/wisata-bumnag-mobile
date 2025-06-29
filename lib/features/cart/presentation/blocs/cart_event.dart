part of 'cart_bloc.dart';

@freezed
abstract class CartEvent with _$CartEvent {
  const factory CartEvent.started() = _CartStarted;
  const factory CartEvent.decisionChecked(
    Pair<DestinationSouvenir, Souvenir> temporary,
  ) = _CartDecisionChecked;
  const factory CartEvent.souvenirAddButtonPressed({
    required int quantity,
    required DestinationSouvenir destinationSouvenir,
    required Souvenir souvenir,
  }) = _CartSouvenirAddButtonPressed;
  const factory CartEvent.saveToCartButtonPressed() =
      _CartSaveToCartButtonPressed;
  const factory CartEvent.addButtonPressed({
    required CartSouvenir destinationSouvenir,
    required Orderable orderable,
    int? quantity,
  }) = _CartAddButtonPressed;
  const factory CartEvent.removeButtonPressed({
    required CartSouvenir destinationSouvenir,
    required Orderable orderable,
  }) = _CartRemoveButtonPressed;
  const factory CartEvent.deleteButtonPressed({
    required CartSouvenir destinationSouvenir,
    required Orderable orderable,
  }) = _CartDeleteButtonPressed;
  const factory CartEvent.saveButtonPressed() = _CartSaveButtonPressed;
  const factory CartEvent.currentRemoved(CartSouvenir cartSouvenir) =
      _CartCurrentRemoved;
}
