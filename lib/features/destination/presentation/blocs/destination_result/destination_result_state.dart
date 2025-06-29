part of 'destination_result_bloc.dart';

@freezed
abstract class DestinationResultState with _$DestinationResultState {
  const factory DestinationResultState({
    required DestinationResultStatus status,
    required List<Destination> destinations,
    required Option<Either<Failure, Paginable<Destination>>>
        destinationsOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required bool isLoadMore,
  }) = _DestinationResultState;
  factory DestinationResultState.initial() => DestinationResultState(
        status: DestinationResultStatus.initial,
        destinations: [],
        destinationsOrFailureOption: none(),
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

enum DestinationResultStatus {
  initial,
  success,
  failure,
}
