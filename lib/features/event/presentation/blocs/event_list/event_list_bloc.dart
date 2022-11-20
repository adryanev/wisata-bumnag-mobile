import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/event/domain/entities/event.entity.dart';
import 'package:wisatabumnag/features/event/domain/usecases/get_events.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';
part 'event_list_bloc.freezed.dart';

@injectable
class EventListBloc extends Bloc<EventListEvent, EventListState> {
  EventListBloc(this._getEvent) : super(EventListState.initial()) {
    on<_EventListStarted>(
      _onStarted,
      transformer: throttleDroppable(
        const Duration(
          milliseconds: 300,
        ),
      ),
    );
  }
  final GetEvent _getEvent;

  FutureOr<void> _onStarted(
    _EventListStarted event,
    Emitter<EventListState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.events.isEmpty) {
      final result = await _getEvent(const GetEventParams());
      if (result.isRight()) {
        final events = result.getRight();
        emit(
          state.copyWith(
            events: events!.data,
            pagination: events.pagination,
            hasReachedMax:
                events.pagination.lastPage == state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          eventPaginationOrFailureOption: optionOf(result),
          status: result.isRight()
              ? EventListStatus.success
              : EventListStatus.failure,
        ),
      );
    }

    final result = await _getEvent(
      GetEventParams(
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final events = result.getRight();
      emit(
        state.copyWith(
          events: List.of(state.events)
            ..addAll(
              events!.data,
            ),
          pagination: events.pagination,
          hasReachedMax:
              events.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    emit(
      state.copyWith(
        eventPaginationOrFailureOption: optionOf(result),
        status: result.isRight()
            ? EventListStatus.success
            : EventListStatus.failure,
      ),
    );
    emit(
      state.copyWith(
        eventPaginationOrFailureOption: none(),
      ),
    );
  }
}
