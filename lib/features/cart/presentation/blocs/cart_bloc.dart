import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/core/extensions/language/pair.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/features/cart/domain/usecases/get_user_cart.dart';
import 'package:wisatabumnag/features/cart/domain/usecases/save_cart.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';

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
    on<_CartSaveButtonPressed>(_onSaveButtonPressed);
    on<_CartDecisionChecked>(_onDecisionChecked);
    on<_CartSouvenirAddButtonPressed>(_onCartSouvenirAddPressed);
    on<_CartSaveToCartButtonPressed>(_onSaveToCartPressed);
  }

  final GetUserCart _getUserCart;
  final SaveCart _saveCart;

  FutureOr<void> _onStarted(
    _CartStarted event,
    Emitter<CartState> emit,
  ) async {
    final previousState = state.status;
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
        status: previousState,
      ),
    );
  }

  FutureOr<void> _onAddButtonPressed(
    _CartAddButtonPressed event,
    Emitter<CartState> emit,
  ) {
    final destinationSouvenir = state.cartSouvenir.firstWhereOrNull(
      (element) =>
          element.destinationId == event.destinationSouvenir.destinationId,
    );
    final destinationSouvenirIndex = state.cartSouvenir.indexWhere(
      (element) =>
          element.destinationId == event.destinationSouvenir.destinationId,
    );
    // if souvenir cart not exist then add new entry to cart
    if (destinationSouvenir == null) {
      final cart = CartSouvenir(
        destinationId: event.destinationSouvenir.destinationId,
        destinationName: event.destinationSouvenir.destinationName,
        destinationAddress: event.destinationSouvenir.destinationAddress,
        items: [event.orderable],
      );
      emit(
        state.copyWith(
          cartSouvenir: [...state.cartSouvenir, cart],
          temporary: null,
        ),
      );
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
      emit(
        state.copyWith(
          cartSouvenir: [...temporary],
          temporary: null,
        ),
      );
      return null;
    }

    final temporaryItems = [...destinationSouvenir.items];
    final newQuantity = currentOrderable.quantity + (event.quantity ?? 1);
    final newOrderable = currentOrderable.copyWith(
      quantity: newQuantity,
      subtotal: currentOrderable.price * newQuantity,
    );
    temporaryItems[currentOrderableIndex] = newOrderable;

    final temporary = [...state.cartSouvenir];

    final newDestinationSouvenir =
        destinationSouvenir.copyWith(items: [...temporaryItems]);

    temporary[destinationSouvenirIndex] = newDestinationSouvenir;
    emit(
      state.copyWith(
        cartSouvenir: [...temporary],
        temporary: null,
      ),
    );
  }

  FutureOr<void> _onRemoveButtonPressed(
    _CartRemoveButtonPressed event,
    Emitter<CartState> emit,
  ) {
    final destinationSouvenir = state.cartSouvenir.firstWhereOrNull(
      (element) =>
          element.destinationId == event.destinationSouvenir.destinationId,
    );
    final destinationSouvenirIndex = state.cartSouvenir.indexWhere(
      (element) =>
          element.destinationId == event.destinationSouvenir.destinationId,
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
    emit(
      state.copyWith(
        cartSouvenir: [...temporary],
        temporary: null,
      ),
    );
  }

  FutureOr<void> _onDeleteButtonPressed(
    _CartDeleteButtonPressed event,
    Emitter<CartState> emit,
  ) {
    final destinationSouvenir = state.cartSouvenir.firstWhereOrNull(
      (element) =>
          element.destinationId == event.destinationSouvenir.destinationId,
    );
    final destinationSouvenirIndex = state.cartSouvenir.indexWhere(
      (element) =>
          element.destinationId == event.destinationSouvenir.destinationId,
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
      emit(
        state.copyWith(
          cartSouvenir: [...temporary],
          temporary: null,
        ),
      );
      return null;
    }

    final newDestinationSouvenir =
        destinationSouvenir.copyWith(items: [...temporaryItems]);

    temporary[destinationSouvenirIndex] = newDestinationSouvenir;
    emit(
      state.copyWith(
        cartSouvenir: [...temporary],
        temporary: null,
      ),
    );
  }

  FutureOr<void> _onSaveButtonPressed(
    _CartSaveButtonPressed event,
    Emitter<CartState> emit,
  ) {
    log('data: ${state.cartSouvenir}');

    // final orderables =
    //     state.cartSouvenir.fold(<Orderable>[], (e, v) => [...v.items]);
  }

  FutureOr<void> _onDecisionChecked(
    _CartDecisionChecked event,
    Emitter<CartState> emit,
  ) {
    final previous = state.status;
    emit(
      state.copyWith(temporary: event.temporary, status: CartStatus.temporary),
    );
    emit(state.copyWith(status: previous));
  }

  FutureOr<void> _onCartSouvenirAddPressed(
    _CartSouvenirAddButtonPressed event,
    Emitter<CartState> emit,
  ) async {
    final orderable = OrderableMapper.fromSouvenir(event.souvenir);
    add(
      CartEvent.addButtonPressed(
        destinationSouvenir: CartSouvenir(
          destinationId: event.destinationSouvenir.id,
          destinationName: event.destinationSouvenir.name,
          destinationAddress: event.destinationSouvenir.address,
          items: [
            orderable.copyWith(quantity: event.quantity),
          ],
        ),
        orderable: orderable.copyWith(quantity: event.quantity),
        quantity: event.quantity,
      ),
    );
    add(const CartEvent.saveToCartButtonPressed());
  }

  FutureOr<void> _onSaveToCartPressed(
    _CartSaveToCartButtonPressed event,
    Emitter<CartState> emit,
  ) async {
    final currentCart = state.cartSouvenir;
    final result = await _saveCart(SaveCartParams(currentCart));
    emit(state.copyWith(cartSavedOrFailureOption: optionOf(result)));
    emit(state.copyWith(cartSavedOrFailureOption: none()));
  }
}
