import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/usecases/get_souvenir_by_destination.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/create_order.dart';

part 'destination_order_event.dart';
part 'destination_order_state.dart';
part 'destination_order_bloc.freezed.dart';

@injectable
class DestinationOrderBloc
    extends Bloc<DestinationOrderEvent, DestinationOrderState> {
  DestinationOrderBloc(this._getSouvenirByDestination, this._createOrder)
      : super(DestinationOrderState.initial()) {
    on<_DestinationOrderStarted>(_onStarted);
    on<_DestinationOrderForDateChanged>(_onDateChanged);
    on<_DestinationOrderTicketAddButtonPressed>(_onTicketAddButtonPressed);
    on<_DestinationOrderTicketRemoveButtonPressed>(
      _onTicketRemoveButtonPressed,
    );
    on<_DestinationOrderSouvenirAddCartButtonPressed>(
      _onSouvenirAddCartButtonPressed,
    );
    on<_DestinationOrderSouvenirCartAddButtonPressed>(
      _onSouvenirCartAddButtonPressed,
    );
    on<_DestinationOrderSouvenirCartRemoveButtonPressed>(
      _onSouvenirCartRemoveButtonPressed,
    );
    on<_DestinationOrderSouvenirCartDeleteButtonPressed>(
      _onSouvenirCartDeleteButtonPressed,
    );
    on<_DestinationOrderProceedToPaymentButtonPressed>(
      _onProceedToPaymentPressed,
    );
  }

  final GetSouvenirByDestination _getSouvenirByDestination;
  final CreateOrder _createOrder;

  FutureOr<void> _onStarted(
    _DestinationOrderStarted event,
    Emitter<DestinationOrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final details = event.destinationDetail;
    final souvenirResult = await _getSouvenirByDestination(
      GetSouvenirByDestinationParams(
        destinationId: details.id.toString(),
      ),
    );
    if (souvenirResult.isRight()) {
      final souvenir = souvenirResult.getRight();
      emit(state.copyWith(souvenirs: List.of(souvenir!)));
    }
    emit(
      state.copyWith(
        tickets: details.tickets,
        souvenirsOrFailureOption: optionOf(souvenirResult),
        destinationDetail: details,
      ),
    );

    emit(state.copyWith(isLoading: false, souvenirsOrFailureOption: none()));
  }

  FutureOr<void> _onDateChanged(
    _DestinationOrderForDateChanged event,
    Emitter<DestinationOrderState> emit,
  ) {
    emit(state.copyWith(orderForDate: event.dateTime));
  }

  FutureOr<void> _onTicketAddButtonPressed(
    _DestinationOrderTicketAddButtonPressed event,
    Emitter<DestinationOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.ticketable.id &&
          element.type == OrderableType.ticket,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.ticketable.id &&
          element.type == OrderableType.ticket,
    );
    if (current == null) {
      final orderable = OrderableMapper.fromTicket(event.ticketable);

      emit(state.copyWith(cart: [...state.cart, orderable]));
    } else {
      final temporary = [...state.cart];
      final newQuantity = current.quantity + 1;
      final newTicketable = current.copyWith(
        quantity: newQuantity,
        subtotal: current.price * newQuantity,
      );
      temporary[currentIndex] = newTicketable;

      emit(state.copyWith(cart: [...temporary]));
    }
  }

  FutureOr<void> _onTicketRemoveButtonPressed(
    _DestinationOrderTicketRemoveButtonPressed event,
    Emitter<DestinationOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.ticketable.id &&
          element.type == OrderableType.ticket,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.ticketable.id &&
          element.type == OrderableType.ticket,
    );
    if (current == null) {
      return null;
    }
    if (current.quantity > 1) {
      final temporary = [...state.cart];
      final newQuantity = current.quantity - 1;
      final newTicketable = current.copyWith(
        quantity: newQuantity,
        subtotal: current.price * newQuantity,
      );
      temporary[currentIndex] = newTicketable;

      emit(state.copyWith(cart: [...temporary]));
      return null;
    }

    final temporary = [...state.cart]..removeWhere(
        (element) =>
            element.id == event.ticketable.id &&
            element.type == OrderableType.ticket,
      );
    emit(state.copyWith(cart: [...temporary]));
  }

  FutureOr<void> _onSouvenirAddCartButtonPressed(
    _DestinationOrderSouvenirAddCartButtonPressed event,
    Emitter<DestinationOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    if (current == null) {
      final orderable = OrderableMapper.fromSouvenir(event.souvenir);

      emit(state.copyWith(cart: [...state.cart, orderable]));
      return null;
    }
    final temporary = [...state.cart];
    final newQuantity = current.quantity + 1;
    final newSouvenir = current.copyWith(
      quantity: newQuantity,
      subtotal: current.price * newQuantity,
    );
    temporary[currentIndex] = newSouvenir;

    emit(state.copyWith(cart: [...temporary]));
  }

  FutureOr<void> _onSouvenirCartAddButtonPressed(
    _DestinationOrderSouvenirCartAddButtonPressed event,
    Emitter<DestinationOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    if (current == null) {
      return null;
    }
    final temporary = [...state.cart];
    final newQuantity = current.quantity + 1;
    final newSouvenir = current.copyWith(
      quantity: newQuantity,
      subtotal: current.price * newQuantity,
    );
    temporary[currentIndex] = newSouvenir;

    emit(state.copyWith(cart: [...temporary]));
  }

  FutureOr<void> _onSouvenirCartRemoveButtonPressed(
    _DestinationOrderSouvenirCartRemoveButtonPressed event,
    Emitter<DestinationOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    if (current == null) {
      return null;
    }
    final temporary = [...state.cart];
    final newQuantity = current.quantity - 1;
    final newSouvenir = current.copyWith(
      quantity: newQuantity,
      subtotal: current.price * newQuantity,
    );
    temporary[currentIndex] = newSouvenir;

    emit(state.copyWith(cart: [...temporary]));
  }

  FutureOr<void> _onSouvenirCartDeleteButtonPressed(
    _DestinationOrderSouvenirCartDeleteButtonPressed event,
    Emitter<DestinationOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.souvenir.id &&
          element.type == OrderableType.souvenir,
    );
    if (current == null) {
      return null;
    }
    final temporary = [...state.cart]..removeAt(currentIndex);

    emit(state.copyWith(cart: [...temporary]));
  }

  FutureOr<void> _onProceedToPaymentPressed(
    _DestinationOrderProceedToPaymentButtonPressed event,
    Emitter<DestinationOrderState> emit,
  ) async {
    final cart = state.cart;
    final form = OrderForm(
      totalPrice: cart
          .map((e) => e.subtotal)
          .fold<double>(0, (previousValue, element) => previousValue + element),
      orderDate: state.orderForDate,
      orderDetails: cart,
    );

    emit(state.copyWith(isSubmitting: true));
    final result = await _createOrder(
      CreateOrderParams(form),
    );

    emit(state.copyWith(createOrderOfFailureOption: optionOf(result)));
    emit(
      state.copyWith(createOrderOfFailureOption: none(), isSubmitting: false),
    );
  }
}
