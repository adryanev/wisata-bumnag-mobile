import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/domain/usecases/get_destination_detail.dart';

part 'destination_detail_event.dart';
part 'destination_detail_state.dart';
part 'destination_detail_bloc.freezed.dart';

@injectable
class DestinationDetailBloc
    extends Bloc<DestinationDetailEvent, DestinationDetailState> {
  DestinationDetailBloc(this._getDestinationDetail)
      : super(DestinationDetailState.initial()) {
    on<_DestinationDetailStarted>(_onStarted);
  }
  final GetDestinationDetail _getDestinationDetail;

  FutureOr<void> _onStarted(
    _DestinationDetailStarted event,
    Emitter<DestinationDetailState> emit,
  ) async {
    if (event.destinationId == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await _getDestinationDetail(
      GetDestinationDetailParams(
        destinationId: event.destinationId!,
      ),
    );
    if (result.isRight()) {
      final detail = result.getRight();
      emit(state.copyWith(destinationDetail: detail));
    }

    emit(state.copyWith(destinationDetailOrFailureOption: optionOf(result)));
    emit(
      state.copyWith(
        destinationDetailOrFailureOption: none(),
        isLoading: false,
      ),
    );
  }
}
