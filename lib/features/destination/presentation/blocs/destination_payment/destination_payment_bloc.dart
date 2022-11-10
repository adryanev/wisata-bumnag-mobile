import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

part 'destination_payment_event.dart';
part 'destination_payment_state.dart';
part 'destination_payment_bloc.freezed.dart';

@injectable
class DestinationPaymentBloc
    extends Bloc<DestinationPaymentEvent, DestinationPaymentState> {
  DestinationPaymentBloc() : super(DestinationPaymentState.initial()) {
    on<_DestinationPaymentStarted>(_onStarted);
    on<_DestinationPaymentTypeChanged>(_onPaymentTypeChanged);
  }

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
}
