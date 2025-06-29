part of 'package_list_bloc.dart';

@freezed
abstract class PackageListState with _$PackageListState {
  const factory PackageListState({
    required PackageListStatus status,
    required List<Package> packages,
    required Option<Either<Failure, Paginable<Package>>>
        packagePaginationOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required bool isLoadMore,
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
        isLoadMore: false,
      );
}

enum PackageListStatus { initial, failure, success }
