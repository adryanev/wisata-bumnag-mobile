part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.started() = _CartStarted;
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

  const factory CartEvent.selected(Orderable orderable) = _CartSelected;
  const factory CartEvent.deselected(Orderable orderable) = _CartDeselected;
}
