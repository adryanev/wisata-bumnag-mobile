import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination.entity.dart';
import 'package:wisatabumnag/features/destination/domain/usecases/get_destination.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';

part 'destination_result_event.dart';
part 'destination_result_state.dart';
part 'destination_result_bloc.freezed.dart';

@injectable
class DestinationResultBloc
    extends Bloc<DestinationResultEvent, DestinationResultState> {
  DestinationResultBloc(this._getDestination)
      : super(DestinationResultState.initial()) {
    on<DestinationResultFetched>(
      _onDestinationResultFetched,
      transformer: throttleDroppable(
        const Duration(
          milliseconds: 300,
        ),
      ),
    );
    on<DestinationResultRefreshed>(_onRefreshed);
  }

  final GetDestination _getDestination;

  FutureOr<void> _onDestinationResultFetched(
    DestinationResultFetched event,
    Emitter<DestinationResultState> emit,
  ) async {
    if (state.hasReachedMax) return emit(state.copyWith());
    if (state.destinations.isEmpty) {
      final result =
          await _getDestination(GetDestinationParams(category: event.category));
      if (result.isRight()) {
        final destinations = result.getRight();
        emit(
          state.copyWith(
            destinations: destinations!.data,
            pagination: destinations.pagination,
            hasReachedMax: destinations.pagination.lastPage ==
                state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          destinationsOrFailureOption: optionOf(result),
          status: result.isRight()
              ? DestinationResultStatus.success
              : DestinationResultStatus.failure,
        ),
      );
    }

    emit(state.copyWith(isLoadMore: true));

    final result = await _getDestination(
      GetDestinationParams(
        category: event.category,
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final destinations = result.getRight();
      emit(
        state.copyWith(
          destinations: List.of(state.destinations)
            ..addAll(
              destinations!.data,
            ),
          pagination: destinations.pagination,
          hasReachedMax:
              destinations.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    return emit(
      state.copyWith(
        destinationsOrFailureOption: optionOf(result),
        isLoadMore: false,
        status: result.isRight()
            ? DestinationResultStatus.success
            : DestinationResultStatus.failure,
      ),
    );
  }

  FutureOr<void> _onRefreshed(
    DestinationResultRefreshed event,
    Emitter<DestinationResultState> emit,
  ) {
    emit(DestinationResultState.initial());
    add(DestinationResultEvent.fetched(event.category));
  }
}
