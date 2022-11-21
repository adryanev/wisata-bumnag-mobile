part of 'explore_bloc.dart';

@freezed
class ExploreState with _$ExploreState {
  const factory ExploreState({
    required ExploreStatus status,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required Option<Either<Failure, Paginable<Explore>>>
        explorePaginationOrFailureOption,
    required List<Explore> explores,
  }) = _ExploreState;
  factory ExploreState.initial() => ExploreState(
        status: ExploreStatus.initial,
        hasReachedMax: false,
        currentPage: 1,
        pagination: const Pagination(
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: 0,
        ),
        explorePaginationOrFailureOption: none(),
        explores: [],
      );
}

enum ExploreStatus { initial, failure, success }
