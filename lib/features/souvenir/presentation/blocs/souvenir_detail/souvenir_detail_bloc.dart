import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir_detail.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/usecases/get_souvenir_detail.dart';

part 'souvenir_detail_event.dart';
part 'souvenir_detail_state.dart';
part 'souvenir_detail_bloc.freezed.dart';

@injectable
class SouvenirDetailBloc
    extends Bloc<SouvenirDetailEvent, SouvenirDetailState> {
  SouvenirDetailBloc(this._getSouvenirDetail)
      : super(
          SouvenirDetailState.initial(),
        ) {
    on<_SouveniDetailStarted>(_onStarted);
  }
  final GetSouvenirDetail _getSouvenirDetail;

  FutureOr<void> _onStarted(
    _SouveniDetailStarted event,
    Emitter<SouvenirDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result =
        await _getSouvenirDetail(GetSouvenirDetailParams(event.souvenirId));
    if (result.isRight()) {
      emit(
        state.copyWith(
          souvenirDetail: result.getRight(),
        ),
      );
    }
    emit(state.copyWith(souvenirDetailOrFailureOption: optionOf(result)));
    emit(
      state.copyWith(isLoading: false, souvenirDetailOrFailureOption: none()),
    );
  }
}
