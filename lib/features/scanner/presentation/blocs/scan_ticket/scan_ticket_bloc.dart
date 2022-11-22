import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/scan_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/usecases/scan_ticket.dart';

part 'scan_ticket_event.dart';
part 'scan_ticket_state.dart';
part 'scan_ticket_bloc.freezed.dart';

@injectable
class ScanTicketBloc extends Bloc<ScanTicketEvent, ScanTicketState> {
  ScanTicketBloc(this._scanTicket) : super(ScanTicketState.initial()) {
    on<_ScanTicketBarcodeScanned>(_onScanned);
  }

  final ScanTicket _scanTicket;

  FutureOr<void> _onScanned(
    _ScanTicketBarcodeScanned event,
    Emitter<ScanTicketState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final rawData = event.barcodeData;
    final separated = rawData.split(';');
    final number = separated.firstOrNull?.substring(4);
    final orderDate = DateTime.tryParse(separated.lastOrNull ?? '');
    if (number == null || orderDate == null) {
      return emit(
        state.copyWith(
          isLoading: false,
          checkedOrFailureOption: optionOf(
            left(
              const LocalFailure(
                message: 'Tidak bisa mendapatkan data dari QR',
              ),
            ),
          ),
        ),
      );
    }
    final result = await _scanTicket(
      ScanTicketParams(
        ScanTicketForm(number: number, orderDate: orderDate),
      ),
    );
    emit(
      state.copyWith(
        checkedOrFailureOption: optionOf(result),
        isLoading: false,
      ),
    );
    emit(
      state.copyWith(
        checkedOrFailureOption: none(),
      ),
    );
  }
}
