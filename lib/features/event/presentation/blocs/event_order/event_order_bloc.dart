import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/create_order.dart';

part 'event_order_event.dart';
part 'event_order_state.dart';
part 'event_order_bloc.freezed.dart';

@injectable
class EventOrderBloc extends Bloc<EventOrderEvent, EventOrderState> {
  EventOrderBloc(this._createOrder) : super(EventOrderState.initial()) {
    on<_EventOrderStarted>(_onStarted);
    on<_EventOrderForDateChanged>(_onDateChanged);
    on<_EventOrderTicketAddButtonPressed>(_onTicketAddButtonPressed);
    on<_EventOrderTicketRemoveButtonPressed>(
      _onTicketRemoveButtonPressed,
    );
    on<_EventOrderProceedToPaymentButtonPressed>(
      _onProceedToPaymentPressed,
    );
  }

  final CreateOrder _createOrder;

  FutureOr<void> _onStarted(
    _EventOrderStarted event,
    Emitter<EventOrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final details = event.eventDetail;
    final date = event.eventDetail.startDate;

    emit(
      state.copyWith(
        tickets: details.tickets,
        eventDetail: details,
        orderForDate: date,
      ),
    );

    emit(
      state.copyWith(
        isLoading: false,
      ),
    );
  }

  FutureOr<void> _onDateChanged(
    _EventOrderForDateChanged event,
    Emitter<EventOrderState> emit,
  ) {
    emit(state.copyWith(orderForDate: event.dateTime));
  }

  FutureOr<void> _onTicketAddButtonPressed(
    _EventOrderTicketAddButtonPressed event,
    Emitter<EventOrderState> emit,
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
    _EventOrderTicketRemoveButtonPressed event,
    Emitter<EventOrderState> emit,
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

  FutureOr<void> _onProceedToPaymentPressed(
    _EventOrderProceedToPaymentButtonPressed event,
    Emitter<EventOrderState> emit,
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
