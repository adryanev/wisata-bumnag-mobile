part of 'review_history_bloc.dart';

@freezed
abstract class ReviewHistoryState with _$ReviewHistoryState {
  const factory ReviewHistoryState({
    required ReviewHistory status,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required Option<Either<Failure, Paginable<OrderDetail>>>
        orderDetailPaginationOrFailureOption,
    required List<OrderDetail> orderDetails,
    required bool isLoadMore,
  }) = _ReviewHistoryState;
  factory ReviewHistoryState.initial() => ReviewHistoryState(
        status: ReviewHistory.initial,
        hasReachedMax: false,
        currentPage: 1,
        pagination: const Pagination(
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: 0,
        ),
        orderDetailPaginationOrFailureOption: none(),
        orderDetails: [],
        isLoadMore: false,
      );
}

enum ReviewHistory { initial, failure, success }
