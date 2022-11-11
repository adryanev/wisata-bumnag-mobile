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

part 'destination_payment_event.dart';
part 'destination_payment_state.dart';
part 'destination_payment_bloc.freezed.dart';

@injectable
class DestinationPaymentBloc
    extends Bloc<DestinationPaymentEvent, DestinationPaymentState> {
  DestinationPaymentBloc(
    this._createPaymentOnline,
    this._createPaymentOnsite,
  ) : super(DestinationPaymentState.initial()) {
    on<_DestinationPaymentStarted>(_onStarted);
    on<_DestinationPaymentTypeChanged>(_onPaymentTypeChanged);
    on<_DestinationPaymentPayButtonPressed>(_onPayButtonPressed);
  }

  final CreatePaymentOnline _createPaymentOnline;
  final CreatePaymentOnsite _createPaymentOnsite;

  FutureOr<void> _onStarted(
    _DestinationPaymentStarted event,
    Emitter<DestinationPaymentState> emit,
  ) {
    emit(state.copyWith(order: event.order));
  }

  FutureOr<void> _onPaymentTypeChanged(
    _DestinationPaymentTypeChanged event,
    Emitter<DestinationPaymentState> emit,
  ) {
    emit(state.copyWith(paymentType: event.paymentType));
  }

  FutureOr<void> _onPayButtonPressed(
    _DestinationPaymentPayButtonPressed event,
    Emitter<DestinationPaymentState> emit,
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
