import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/approve_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/payment_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/usecases/approve_ticket.dart';
import 'package:wisatabumnag/features/scanner/domain/usecases/pay_ticket.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

part 'scan_detail_event.dart';
part 'scan_detail_state.dart';
part 'scan_detail_bloc.freezed.dart';

@injectable
class ScanDetailBloc extends Bloc<ScanDetailEvent, ScanDetailState> {
  ScanDetailBloc(this._approveTicket, this._payTicket)
      : super(ScanDetailState.initial()) {
    on<_ScanDetailStarted>(_onStarted);
    on<_ScanDetailPayNowButtonPressed>(_onPayPressed);
    on<_ScanDetailApproveButtonPressed>(_onApprovePressed);
  }

  final ApproveTicket _approveTicket;
  final PayTicket _payTicket;

  FutureOr<void> _onStarted(
    _ScanDetailStarted event,
    Emitter<ScanDetailState> emit,
  ) {
    final data = event.orderHistoryItem;

    emit(
      state.copyWith(
        orderHistoryItem: data,
      ),
    );
    if (data.order.status == OrderStatus.paid) {
      emit(state.copyWith(isPaid: true));
    }
  }

  FutureOr<void> _onPayPressed(
    _ScanDetailPayNowButtonPressed event,
    Emitter<ScanDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _payTicket(
      PayTicketParams(
        PaymentTicketForm(
          orderNumber: state.orderHistoryItem!.order.number,
        ),
      ),
    );
    if (result.isRight()) {
      emit(state.copyWith(isPaid: true));
    }
    emit(state.copyWith(payTicketOrFailureOption: optionOf(result)));
    emit(state.copyWith(payTicketOrFailureOption: none(), isLoading: false));
  }

  FutureOr<void> _onApprovePressed(
    _ScanDetailApproveButtonPressed event,
    Emitter<ScanDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _approveTicket(
      ApproveTicketParams(
        ApproveTicketForm(
          number: state.orderHistoryItem!.order.number,
          orderDate: state.orderHistoryItem!.order.orderDate,
        ),
      ),
    );
    if (result.isRight()) {}
    emit(state.copyWith(approveTicketOrFailureOption: optionOf(result)));
    emit(
      state.copyWith(
        approveTicketOrFailureOption: none(),
        isLoading: false,
      ),
    );
  }
}
