part of 'review_waiting_bloc.dart';

@freezed
class ReviewWaitingState with _$ReviewWaitingState {
  const factory ReviewWaitingState({
    required ReviewWaiting status,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required Option<Either<Failure, Paginable<OrderDetail>>>
        orderDetailPaginationOrFailureOption,
    required List<OrderDetail> orderDetails,
  }) = _ReviewWaitingState;
  factory ReviewWaitingState.initial() => ReviewWaitingState(
        status: ReviewWaiting.initial,
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

enum ReviewWaiting { initial, failure, success }
