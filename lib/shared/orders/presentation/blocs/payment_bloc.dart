import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/midtrans_payment.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/create_payment_online.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/create_payment_onsite.dart';

part 'payment_event.dart';
part 'payment_state.dart';
part 'payment_bloc.freezed.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(
    this._createPaymentOnline,
    this._createPaymentOnsite,
  ) : super(PaymentState.initial()) {
    on<_PaymentStarted>(_onStarted);
    on<_PaymentTypeChanged>(_onPaymentTypeChanged);
    on<_PaymentPayButtonPressed>(_onPayButtonPressed);
  }

  final CreatePaymentOnline _createPaymentOnline;
  final CreatePaymentOnsite _createPaymentOnsite;

  FutureOr<void> _onStarted(
    _PaymentStarted event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(order: event.order));
  }

  FutureOr<void> _onPaymentTypeChanged(
    _PaymentTypeChanged event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(paymentType: event.paymentType));
  }

  FutureOr<void> _onPayButtonPressed(
    _PaymentPayButtonPressed event,
    Emitter<PaymentState> emit,
  ) async {
    final form = PaymentForm(
      orderNumber: state.order!.number,
      paymentType: state.paymentType,
    );
    emit(state.copyWith(isLoading: true));
    if (state.paymentType == PaymentType.online) {
      final result = await _createPaymentOnline(
        CreatePaymentOnlineParams(form),
      );
      emit(state.copyWith(successOnlineOrFailureOption: optionOf(result)));
    } else {
      final result =
          await _createPaymentOnsite(CreatePaymentOnsiteParams(form));
      emit(state.copyWith(successOnsiteOrFailureOption: optionOf(result)));
    }

    emit(
      state.copyWith(
        successOnlineOrFailureOption: none(),
        successOnsiteOrFailureOption: none(),
        isLoading: false,
      ),
    );
  }
}
