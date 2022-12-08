import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/features/packages/domain/usecases/get_package_detail.dart';

part 'package_detail_event.dart';
part 'package_detail_state.dart';
part 'package_detail_bloc.freezed.dart';

@injectable
class PackageDetailBloc extends Bloc<PackageDetailEvent, PackageDetailState> {
  PackageDetailBloc(this._getPackageDetail)
      : super(PackageDetailState.initial()) {
    on<_PackageDetailStarted>(_onPackageStarted);
  }

  final GetPackageDetail _getPackageDetail;

  FutureOr<void> _onPackageStarted(
    _PackageDetailStarted event,
    Emitter<PackageDetailState> emit,
  ) async {
    if (event.packageId == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await _getPackageDetail(
      GetPackageDetailParams(
        packageId: event.packageId!,
      ),
    );
    if (result.isRight()) {
      final detail = result.getRight();
      emit(state.copyWith(packageDetail: detail));
    }

    emit(state.copyWith(packageDetailOrFailureOption: optionOf(result)));
    emit(
      state.copyWith(
        packageDetailOrFailureOption: none(),
        isLoading: false,
      ),
    );
  }
}
