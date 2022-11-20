import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/features/event/domain/usecases/get_event_detail.dart';

part 'event_detail_event.dart';
part 'event_detail_state.dart';
part 'event_detail_bloc.freezed.dart';

@injectable
class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  EventDetailBloc(this._getEventDetail) : super(EventDetailState.initial()) {
    on<_EventDetailStarted>(_onStarted);
  }

  final GetEventDetail _getEventDetail;

  FutureOr<void> _onStarted(
    _EventDetailStarted event,
    Emitter<EventDetailState> emit,
  ) async {
    if (event.eventId == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await _getEventDetail(
      GetEventDetailParams(
        eventId: event.eventId!,
      ),
    );
    if (result.isRight()) {
      final detail = result.getRight();
      emit(state.copyWith(eventDetail: detail));
    }

    emit(state.copyWith(eventDetailOrFailureOption: optionOf(result)));
    emit(
      state.copyWith(
        eventDetailOrFailureOption: none(),
        isLoading: false,
      ),
    );
  }
}
