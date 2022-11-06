import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/usecases/get_souvenir_by_destination.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/orderable.entity.dart';

part 'destination_order_event.dart';
part 'destination_order_state.dart';
part 'destination_order_bloc.freezed.dart';

@injectable
class DestinationOrderBloc
    extends Bloc<DestinationOrderEvent, DestinationOrderState> {
  DestinationOrderBloc(this._getSouvenirByDestination)
      : super(DestinationOrderState.initial()) {
    on<_DestinationOrderStarted>(_onStarted);
  }

  final GetSouvenirByDestination _getSouvenirByDestination;

  FutureOr<void> _onStarted(
    _DestinationOrderStarted event,
    Emitter<DestinationOrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final details = event.destinationDetail;
    final souvenirResult = await _getSouvenirByDestination(
      GetSouvenirByDestinationParams(
        destinationId: details.id.toString(),
      ),
    );
    if (souvenirResult.isRight()) {
      final souvenir = souvenirResult.getRight();
      emit(state.copyWith(souvenirs: List.of(souvenir!)));
    }
    emit(
      state.copyWith(
        tickets: details.tickets,
        souvenirsOrFailureOption: optionOf(souvenirResult),
        destinationDetail: details,
      ),
    );

    emit(state.copyWith(isLoading: false, souvenirsOrFailureOption: none()));
  }
}
