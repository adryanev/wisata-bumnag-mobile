import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_pagination.entity.dart';
import 'package:wisatabumnag/features/packages/domain/usecases/get_package_detail.dart';
import 'package:wisatabumnag/features/packages/domain/usecases/get_packages.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';

part 'package_list_event.dart';
part 'package_list_state.dart';
part 'package_list_bloc.freezed.dart';

@injectable
class PackageListBloc extends Bloc<PackageListEvent, PackageListState> {
  PackageListBloc(
    this._getPackages,
  ) : super(PackageListState.initial()) {
    on<_PackageListStarted>(_onStarted);
  }
  final GetPackages _getPackages;

  FutureOr<void> _onStarted(
    _PackageListStarted event,
    Emitter<PackageListState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.status == PackageListStatus.initial) {
      final result =
          await _getPackages(GetPackagesParams(category: event.category));
      if (result.isRight()) {
        final packages = result.getRight();
        emit(
          state.copyWith(
            packages: packages!.packages,
            pagination: packages.pagination,
            hasReachedMax:
                packages.pagination.lastPage == state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          packagePaginationOrFailureOption: optionOf(result),
          status: result.isRight()
              ? PackageListStatus.success
              : PackageListStatus.failure,
        ),
      );
    }

    final result = await _getPackages(
      GetPackagesParams(
        category: event.category,
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final packages = result.getRight();
      emit(
        state.copyWith(
          packages: List.of(state.packages)
            ..addAll(
              packages!.packages,
            ),
          pagination: packages.pagination,
          hasReachedMax:
              packages.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    return emit(
      state.copyWith(
        packagePaginationOrFailureOption: optionOf(result),
        status: result.isRight()
            ? PackageListStatus.success
            : PackageListStatus.failure,
      ),
    );
  }
}
