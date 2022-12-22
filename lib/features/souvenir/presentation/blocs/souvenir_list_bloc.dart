import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/usecases/get_souvenirs.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';

part 'souvenir_list_event.dart';
part 'souvenir_list_state.dart';
part 'souvenir_list_bloc.freezed.dart';

@injectable
class SouvenirListBloc extends Bloc<SouvenirListEvent, SouvenirListState> {
  SouvenirListBloc(this._getSouvenirs) : super(SouvenirListState.initial()) {
    on<_SouvenirListStarted>(
      _onStarted,
      transformer: throttleDroppable(
        const Duration(
          milliseconds: 300,
        ),
      ),
    );
    on<_SouvenirListRefreshed>(_onRefreshed);
  }

  final GetSouvenirs _getSouvenirs;

  FutureOr<void> _onStarted(
    _SouvenirListStarted event,
    Emitter<SouvenirListState> emit,
  ) async {
    if (state.hasReachedMax) return emit(state.copyWith());
    if (state.souvenirs.isEmpty) {
      final result = await _getSouvenirs(const GetSouvenirsParams());
      if (result.isRight()) {
        final souvenirs = result.getRight();
        emit(
          state.copyWith(
            souvenirs: souvenirs!.data,
            pagination: souvenirs.pagination,
            hasReachedMax:
                souvenirs.pagination.lastPage == state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          souvenirsPaginationOrFailureOption: optionOf(result),
          status: result.isRight()
              ? SouvenirListStatus.success
              : SouvenirListStatus.failure,
        ),
      );
    }

    emit(state.copyWith(isLoadMore: true));
    final result = await _getSouvenirs(
      GetSouvenirsParams(
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final souvenirs = result.getRight();
      emit(
        state.copyWith(
          souvenirs: List.of(state.souvenirs)
            ..addAll(
              souvenirs!.data,
            ),
          pagination: souvenirs.pagination,
          hasReachedMax:
              souvenirs.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    emit(
      state.copyWith(
        souvenirsPaginationOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        souvenirsPaginationOrFailureOption: none(),
        status: result.isRight()
            ? SouvenirListStatus.success
            : SouvenirListStatus.failure,
        isLoadMore: false,
      ),
    );
  }

  FutureOr<void> _onRefreshed(
    _SouvenirListRefreshed event,
    Emitter<SouvenirListState> emit,
  ) {
    emit(SouvenirListState.initial());
    add(const SouvenirListEvent.started());
  }
}
