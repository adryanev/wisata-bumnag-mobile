import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/usecases/get_categories_by_parent.dart';

part 'destination_event.dart';
part 'destination_state.dart';
part 'destination_bloc.freezed.dart';

@injectable
class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  DestinationBloc(this._getCategoriesByParent)
      : super(DestinationState.initial()) {
    on<_DestinationStarted>(_onStarted);
  }

  final GetCategoriesByParent _getCategoriesByParent;

  FutureOr<void> _onStarted(
    _DestinationStarted event,
    Emitter<DestinationState> emit,
  ) async {
    final result = await _getCategoriesByParent(
      GetCategoriesByParentParams(category: event.category!),
    );
  }
}
