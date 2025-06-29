part of 'order_list_bloc.dart';

@freezed
abstract class OrderListState with _$OrderListState {
  const factory OrderListState({
    required OrderListStatus status,
    required List<UserOrder> orders,
    required List<OrderHistoryItem> orderHistories,
    required Option<Either<Failure, Paginable<UserOrder>>>
        orderPaginationOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required bool isLoadMore,
  }) = _OrderListState;
  factory OrderListState.initial() => OrderListState(
        orderHistories: [],
        status: OrderListStatus.initial,
        orders: [],
        orderPaginationOrFailureOption: none(),
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

enum OrderListStatus { initial, failure, success }
