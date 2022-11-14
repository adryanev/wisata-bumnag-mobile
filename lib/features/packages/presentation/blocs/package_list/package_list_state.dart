part of 'package_list_bloc.dart';

@freezed
class PackageListState with _$PackageListState {
  const factory PackageListState({
    required PackageListStatus status,
    required List<Package> packages,
    required Option<Either<Failure, PackagePagination>>
        packagePaginationOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
  }) = _PackageListState;
  factory PackageListState.initial() => PackageListState(
        status: PackageListStatus.initial,
        packages: [],
        packagePaginationOrFailureOption: none(),
        hasReachedMax: false,
        currentPage: 1,
        pagination: const Pagination(
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: 0,
        ),
      );
}

enum PackageListStatus { initial, failure, success }
