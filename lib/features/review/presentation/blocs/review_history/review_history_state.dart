part of 'review_history_bloc.dart';

@freezed
class ReviewHistoryState with _$ReviewHistoryState {
  const factory ReviewHistoryState({
    required ReviewHistory status,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required Option<Either<Failure, Paginable<OrderDetail>>>
        orderDetailPaginationOrFailureOption,
    required List<OrderDetail> orderDetails,
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
      );
}

enum ReviewHistory { initial, failure, success }
