import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/home/domain/entities/explore.entity.dart';
import 'package:wisatabumnag/features/home/domain/usecases/get_explore.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';

part 'explore_event.dart';
part 'explore_state.dart';
part 'explore_bloc.freezed.dart';

@injectable
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc(this._getExplore) : super(ExploreState.initial()) {
    on<_ExploreStarted>(_onStarted);
  }
  final GetExplore _getExplore;

  FutureOr<void> _onStarted(
    _ExploreStarted event,
    Emitter<ExploreState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.explores.isEmpty) {
      final result = await _getExplore(const GetExploreParams());
      if (result.isRight()) {
        final explore = result.getRight();

        emit(
          state.copyWith(
            explores: explore!.data,
            pagination: explore.pagination,
            hasReachedMax:
                explore.pagination.lastPage == state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          explorePaginationOrFailureOption: optionOf(result),
          status:
              result.isRight() ? ExploreStatus.success : ExploreStatus.failure,
        ),
      );
    }

    final result = await _getExplore(
      GetExploreParams(
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final explores = result.getRight();
      emit(
        state.copyWith(
          explores: List.of(state.explores)
            ..addAll(
              explores!.data,
            ),
          pagination: explores.pagination,
          hasReachedMax:
              explores.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    emit(
      state.copyWith(
        explorePaginationOrFailureOption: optionOf(result),
        status:
            result.isRight() ? ExploreStatus.success : ExploreStatus.failure,
      ),
    );
    emit(
      state.copyWith(
        explorePaginationOrFailureOption: none(),
      ),
    );
  }
}
