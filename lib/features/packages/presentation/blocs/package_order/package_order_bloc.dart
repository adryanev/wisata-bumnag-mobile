import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/packages/domain/entities/amenity.entity.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/create_order.dart';

part 'package_order_event.dart';
part 'package_order_state.dart';
part 'package_order_bloc.freezed.dart';

@injectable
class PackageOrderBloc extends Bloc<PackageOrderEvent, PackageOrderState> {
  PackageOrderBloc(this._createOrder) : super(PackageOrderState.initial()) {
    on<_PackageOrderStarted>(_onStarted);
    on<_PackageOrderForDateChanged>(_onDateChanged);
    on<_PackageOrderTicketAddButtonPressed>(_onTicketAddButtonPressed);
    on<_PackageOrderTicketRemoveButtonPressed>(
      _onTicketRemoveButtonPressed,
    );
    on<_PackageOrderAmenitiesIncreaseButtonPressed>(_onAmenitiesIncreased);
    on<_PackageOrderAmenitiesDecreaseButtonPressed>(_onAmenitiesDecreased);

    on<_PackageOrderProceedToPaymentButtonPressed>(
      _onProceedToPaymentPressed,
    );
  }

  final CreateOrder _createOrder;

  FutureOr<void> _onStarted(
    _PackageOrderStarted event,
    Emitter<PackageOrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final details = event.packageDetail;

    emit(
      state.copyWith(
        amenities: details.amenities,
        tickets: details.tickets,
        packageDetail: details,
      ),
    );

    emit(
      state.copyWith(
        isLoading: false,
      ),
    );
  }

  FutureOr<void> _onDateChanged(
    _PackageOrderForDateChanged event,
    Emitter<PackageOrderState> emit,
  ) {
    emit(state.copyWith(orderForDate: event.dateTime));
  }

  FutureOr<void> _onTicketAddButtonPressed(
    _PackageOrderTicketAddButtonPressed event,
    Emitter<PackageOrderState> emit,
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
      return null;
    }
    final temporary = [...state.cart];
    final newQuantity = current.quantity + 1;
    final newTicketable = current.copyWith(
      quantity: newQuantity,
      subtotal: current.price * newQuantity,
    );
    temporary[currentIndex] = newTicketable;

    emit(state.copyWith(cart: [...temporary]));
  }

  FutureOr<void> _onTicketRemoveButtonPressed(
    _PackageOrderTicketRemoveButtonPressed event,
    Emitter<PackageOrderState> emit,
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
    _PackageOrderProceedToPaymentButtonPressed event,
    Emitter<PackageOrderState> emit,
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

  FutureOr<void> _onAmenitiesIncreased(
    _PackageOrderAmenitiesIncreaseButtonPressed event,
    Emitter<PackageOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.amenity.id &&
          element.type == OrderableType.amenity,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.amenity.id &&
          element.type == OrderableType.amenity,
    );
    if (current == null) {
      final orderable = OrderableMapper.fromAmenity(event.amenity);

      emit(state.copyWith(cart: [...state.cart, orderable]));
      return null;
    }
    final temporary = [...state.cart];
    final newQuantity = current.quantity + 1;
    final newAmenity = current.copyWith(
      quantity: newQuantity,
      subtotal: current.price * newQuantity,
    );
    temporary[currentIndex] = newAmenity;

    emit(state.copyWith(cart: [...temporary]));
  }

  FutureOr<void> _onAmenitiesDecreased(
    _PackageOrderAmenitiesDecreaseButtonPressed event,
    Emitter<PackageOrderState> emit,
  ) {
    final current = state.cart.firstWhereOrNull(
      (element) =>
          element.id == event.amenity.id &&
          element.type == OrderableType.amenity,
    );
    final currentIndex = state.cart.indexWhere(
      (element) =>
          element.id == event.amenity.id &&
          element.type == OrderableType.amenity,
    );
    if (current == null) {
      return null;
    }
    if (current.quantity > 1) {
      final temporary = [...state.cart];
      final newQuantity = current.quantity - 1;
      final newAmenity = current.copyWith(
        quantity: newQuantity,
        subtotal: current.price * newQuantity,
      );
      temporary[currentIndex] = newAmenity;

      emit(state.copyWith(cart: [...temporary]));
      return null;
    }

    final temporary = [...state.cart]..removeWhere(
        (element) =>
            element.id == event.amenity.id &&
            element.type == OrderableType.amenity,
      );
    emit(state.copyWith(cart: [...temporary]));
  }
}
