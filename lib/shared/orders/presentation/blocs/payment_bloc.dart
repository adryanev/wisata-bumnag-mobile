import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/midtrans_payment.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/create_payment_online.dart';

part 'payment_event.dart';
part 'payment_state.dart';
part 'payment_bloc.freezed.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(
    this._createPaymentOnline,
  ) : super(PaymentState.initial()) {
    on<_PaymentStarted>(_onStarted);
    on<_PaymentPayButtonPressed>(_onPayButtonPressed);
  }

  final CreatePaymentOnline _createPaymentOnline;

  FutureOr<void> _onStarted(
    _PaymentStarted event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(order: event.order));
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

    final result = await _createPaymentOnline(
      CreatePaymentOnlineParams(form),
    );
    emit(state.copyWith(successOnlineOrFailureOption: optionOf(result)));

    emit(
      state.copyWith(
        successOnlineOrFailureOption: none(),
        isLoading: false,
      ),
    );
  }
}
