part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
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
    required DestinationSouvenir destinationSouvenir,
    required Orderable orderable,
  }) = _CartAddButtonPressed;
  const factory CartEvent.removeButtonPressed({
    required DestinationSouvenir destinationSouvenir,
    required Orderable orderable,
  }) = _CartRemoveButtonPressed;
  const factory CartEvent.deleteButtonPressed({
    required DestinationSouvenir destinationSouvenir,
    required Orderable orderable,
  }) = _CartDeleteButtonPressed;
  const factory CartEvent.saveButtonPressed() = _CartSaveButtonPressed;

  const factory CartEvent.selected({
    Orderable? orderable,
    required CartSouvenir cartSouvenir,
  }) = _CartSelected;
  const factory CartEvent.deselected({
    Orderable? orderable,
    required CartSouvenir cartSouvenir,
  }) = _CartDeselected;
}
