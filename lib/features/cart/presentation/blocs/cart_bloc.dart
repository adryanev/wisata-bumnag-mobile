import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<_CartStarted>(_onStarted);
    on<_CartAddButtonPressed>(_onAddButtonPressed);
    on<_CartRemoveButtonPressed>(_onRemoveButtonPressed);
    on<_CartDeleteButtonPressed>(_onDeleteButtonPressed);
    on<_CartSelected>(_onCartSelected);
    on<_CartDeselected>(_onCartDeselected);
    on<_CartSaveButtonPressed>(_onSaveButtonPressed);
  }

  FutureOr<void> _onStarted(
    _CartStarted event,
    Emitter<CartState> emit,
  ) {}

  FutureOr<void> _onAddButtonPressed(
    _CartAddButtonPressed event,
    Emitter<CartState> emit,
  ) {}

  FutureOr<void> _onRemoveButtonPressed(
    _CartRemoveButtonPressed event,
    Emitter<CartState> emit,
  ) {}

  FutureOr<void> _onDeleteButtonPressed(
    _CartDeleteButtonPressed event,
    Emitter<CartState> emit,
  ) {}

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
