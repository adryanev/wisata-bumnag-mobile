import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/home/domain/mappers/order_history_item_mapper.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/usecases/get_order_histories.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';
part 'order_list_bloc.freezed.dart';

@injectable
class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListBloc(this._getOrderHistories) : super(OrderListState.initial()) {
    on<_OrderListStarted>(_onStarted);
    on<_OrderListRefreshed>(_onRefreshed);
  }

  final GetOrderHistories _getOrderHistories;

  FutureOr<void> _onStarted(
    _OrderListStarted event,
    Emitter<OrderListState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.orders.isEmpty) {
      final result = await _getOrderHistories(const GetOrderHistoriesParams());
      if (result.isRight()) {
        final orders = result.getRight();

        emit(
          state.copyWith(
            orderHistories: OrderHistoryItemMapper.mapFromOrderList(
              orders!.data,
            ),
            orders: orders.data,
            pagination: orders.pagination,
            hasReachedMax:
                orders.pagination.lastPage == state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          orderPaginationOrFailureOption: optionOf(result),
          status: result.isRight()
              ? OrderListStatus.success
              : OrderListStatus.failure,
        ),
      );
    }

    emit(state.copyWith(isLoadMore: true));

    final result = await _getOrderHistories(
      GetOrderHistoriesParams(
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final orders = result.getRight();
      emit(
        state.copyWith(
          orderHistories: List.of(state.orderHistories)
            ..addAll(OrderHistoryItemMapper.mapFromOrderList(orders!.data)),
          orders: List.of(state.orders)
            ..addAll(
              orders.data,
            ),
          pagination: orders.pagination,
          hasReachedMax:
              orders.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    emit(
      state.copyWith(
        orderPaginationOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        orderPaginationOrFailureOption: none(),
        status: result.isRight()
            ? OrderListStatus.success
            : OrderListStatus.failure,
        isLoadMore: false,
      ),
    );
  }

  FutureOr<void> _onRefreshed(
    _OrderListRefreshed event,
    Emitter<OrderListState> emit,
  ) {
    emit(OrderListState.initial());
    add(const OrderListEvent.started());
  }
}
