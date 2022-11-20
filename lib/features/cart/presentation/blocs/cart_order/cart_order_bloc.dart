import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/create_order.dart';

part 'cart_order_event.dart';
part 'cart_order_state.dart';
part 'cart_order_bloc.freezed.dart';

@injectable
class CartOrderBloc extends Bloc<CartOrderEvent, CartOrderState> {
  CartOrderBloc(this._createOrder) : super(CartOrderState.initial()) {
    on<_CartOrderStarted>(_onStarted);
    on<_CartOrderDateChanged>(_onDateChanged);
    on<_CartOrderProceedToPaymentPressed>(_onProceedToPayment);
  }

  final CreateOrder _createOrder;

  FutureOr<void> _onStarted(
    _CartOrderStarted event,
    Emitter<CartOrderState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(cartSouvenir: event.cart));
    emit(state.copyWith(isLoading: false));
  }

  FutureOr<void> _onProceedToPayment(
    _CartOrderProceedToPaymentPressed event,
    Emitter<CartOrderState> emit,
  ) async {
    final cart = state.cartSouvenir;
    final form = OrderForm(
      totalPrice: cart!.items
          .map((e) => e.subtotal)
          .fold<double>(0, (previousValue, element) => previousValue + element),
      orderDate: state.orderDate,
      orderDetails: cart.items,
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

  FutureOr<void> _onDateChanged(
    _CartOrderDateChanged event,
    Emitter<CartOrderState> emit,
  ) {
    emit(
      state.copyWith(
        orderDate: event.date,
      ),
    );
  }
}
