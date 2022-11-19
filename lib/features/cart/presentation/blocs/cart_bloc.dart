import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/features/cart/domain/usecases/get_user_cart.dart';
import 'package:wisatabumnag/features/cart/domain/usecases/save_cart.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._getUserCart, this._saveCart) : super(CartState.initial()) {
    on<_CartStarted>(_onStarted);
    on<_CartAddButtonPressed>(_onAddButtonPressed);
    on<_CartRemoveButtonPressed>(_onRemoveButtonPressed);
    on<_CartDeleteButtonPressed>(_onDeleteButtonPressed);
    on<_CartSelected>(_onCartSelected);
    on<_CartDeselected>(_onCartDeselected);
    on<_CartSaveButtonPressed>(_onSaveButtonPressed);
  }

  final GetUserCart _getUserCart;
  final SaveCart _saveCart;

  FutureOr<void> _onStarted(
    _CartStarted event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.fetching));

    final result = await _getUserCart(NoParams());
    if (result.isRight()) {
      emit(
        state.copyWith(
          cartSouvenir: result.getRight()!,
        ),
      );
    }
    emit(state.copyWith(cartSouvenirOrFailureOption: optionOf(result)));
    emit(
      state.copyWith(
        cartSouvenirOrFailureOption: none(),
        status: CartStatus.initial,
      ),
    );
  }

  FutureOr<void> _onAddButtonPressed(
    _CartAddButtonPressed event,
    Emitter<CartState> emit,
  ) {
    final destinationSouvenir = state.cartSouvenir.firstWhereOrNull(
      (element) => element.destinationId == event.destinationSouvenir.id,
    );
    final destinationSouvenirIndex = state.cartSouvenir.indexWhere(
      (element) => element.destinationId == event.destinationSouvenir.id,
    );
    // if souvenir cart not exist then add new entry to cart
    if (destinationSouvenir == null) {
      final cart = CartSouvenir(
        destinationId: event.destinationSouvenir.id,
        destinationName: event.destinationSouvenir.name,
        destinationAddress: event.destinationSouvenir.address,
        items: [event.orderable],
      );
      emit(state.copyWith(cartSouvenir: [...state.cartSouvenir, cart]));
      return null;
    }
    // if exist then get current orderable
    final currentOrderable = destinationSouvenir.items.firstWhereOrNull(
      (element) =>
          element.id == event.orderable.id &&
          element.type == event.orderable.type,
    );
    final currentOrderableIndex = destinationSouvenir.items.indexWhere(
      (element) =>
          element.id == event.orderable.id &&
          element.type == event.orderable.type,
    );
    // if not exist then add new orderable to items
    if (currentOrderable == null) {
      final newItems = [
        ...destinationSouvenir.items,
        event.orderable,
      ];
      final temporary = [...state.cartSouvenir];

      final newDestinationSouvenir =
          destinationSouvenir.copyWith(items: newItems);

      temporary[destinationSouvenirIndex] = newDestinationSouvenir;
      emit(state.copyWith(cartSouvenir: [...temporary]));
      return null;
    }

    final temporaryItems = [...destinationSouvenir.items];
    final newQuantity = currentOrderable.quantity + 1;
    final newOrderable = currentOrderable.copyWith(
      quantity: newQuantity,
      subtotal: currentOrderable.price * newQuantity,
    );
    temporaryItems[currentOrderableIndex] = newOrderable;

    final temporary = [...state.cartSouvenir];

    final newDestinationSouvenir =
        destinationSouvenir.copyWith(items: [...temporaryItems]);

    temporary[destinationSouvenirIndex] = newDestinationSouvenir;
    emit(state.copyWith(cartSouvenir: [...temporary]));
  }

  FutureOr<void> _onRemoveButtonPressed(
    _CartRemoveButtonPressed event,
    Emitter<CartState> emit,
  ) {
    final destinationSouvenir = state.cartSouvenir.firstWhereOrNull(
      (element) => element.destinationId == event.destinationSouvenir.id,
    );
    final destinationSouvenirIndex = state.cartSouvenir.indexWhere(
      (element) => element.destinationId == event.destinationSouvenir.id,
    );
    // if souvenir cart not exist then add new entry to cart
    if (destinationSouvenir == null) {
      return null;
    }
    // if exist then get current orderable
    final currentOrderable = destinationSouvenir.items.firstWhereOrNull(
      (element) =>
          element.id == event.orderable.id &&
          element.type == event.orderable.type,
    );
    final currentOrderableIndex = destinationSouvenir.items.indexWhere(
      (element) =>
          element.id == event.orderable.id &&
          element.type == event.orderable.type,
    );
    // if not exist then add new orderable to items
    if (currentOrderable == null) {
      return null;
    }

    final temporaryItems = [...destinationSouvenir.items];
    final newQuantity = currentOrderable.quantity - 1;
    final newOrderable = currentOrderable.copyWith(
      quantity: newQuantity,
      subtotal: currentOrderable.price * newQuantity,
    );
    temporaryItems[currentOrderableIndex] = newOrderable;

    final temporary = [...state.cartSouvenir];

    final newDestinationSouvenir =
        destinationSouvenir.copyWith(items: [...temporaryItems]);

    temporary[destinationSouvenirIndex] = newDestinationSouvenir;
    emit(state.copyWith(cartSouvenir: [...temporary]));
  }

  FutureOr<void> _onDeleteButtonPressed(
    _CartDeleteButtonPressed event,
    Emitter<CartState> emit,
  ) {
    final destinationSouvenir = state.cartSouvenir.firstWhereOrNull(
      (element) => element.destinationId == event.destinationSouvenir.id,
    );
    final destinationSouvenirIndex = state.cartSouvenir.indexWhere(
      (element) => element.destinationId == event.destinationSouvenir.id,
    );
    // if souvenir cart not exist then add new entry to cart
    if (destinationSouvenir == null) {
      return null;
    }
    // if exist then get current orderable
    final currentOrderable = destinationSouvenir.items.firstWhereOrNull(
      (element) =>
          element.id == event.orderable.id &&
          element.type == event.orderable.type,
    );
    final currentOrderableIndex = destinationSouvenir.items.indexWhere(
      (element) =>
          element.id == event.orderable.id &&
          element.type == event.orderable.type,
    );
    // if not exist then add new orderable to items
    if (currentOrderable == null) {
      return null;
    }

    final temporaryItems = [...destinationSouvenir.items]
      ..removeAt(currentOrderableIndex);

    final temporary = [...state.cartSouvenir];

    if (temporaryItems.isEmpty) {
      temporary.removeAt(destinationSouvenirIndex);
      emit(state.copyWith(cartSouvenir: [...temporary]));
      return null;
    }

    final newDestinationSouvenir =
        destinationSouvenir.copyWith(items: [...temporaryItems]);

    temporary[destinationSouvenirIndex] = newDestinationSouvenir;
    emit(state.copyWith(cartSouvenir: [...temporary]));
  }

  FutureOr<void> _onCartSelected(
    _CartSelected event,
    Emitter<CartState> emit,
  ) {}

  FutureOr<void> _onCartDeselected(
    _CartDeselected event,
    Emitter<CartState> emit,
  ) {}

  FutureOr<void> _onSaveButtonPressed(
    _CartSaveButtonPressed event,
    Emitter<CartState> emit,
  ) {}
}
