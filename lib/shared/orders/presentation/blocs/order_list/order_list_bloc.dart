import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
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
  }

  final GetOrderHistories _getOrderHistories;

  FutureOr<void> _onStarted(
    _OrderListStarted event,
    Emitter<OrderListState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.status == OrderListStatus.initial) {
      final result = await _getOrderHistories(const GetOrderHistoriesParams());
      if (result.isRight()) {
        final orders = result.getRight();
        emit(
          state.copyWith(
            orders: orders!.data,
            pagination: orders.pagination,
            hasReachedMax:
                orders.pagination.lastPage == state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          packagePaginationOrFailureOption: optionOf(result),
          status: result.isRight()
              ? OrderListStatus.success
              : OrderListStatus.failure,
        ),
      );
    }

    final result = await _getOrderHistories(
      GetOrderHistoriesParams(
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final orders = result.getRight();
      emit(
        state.copyWith(
          orders: List.of(state.orders)
            ..addAll(
              orders!.data,
            ),
          pagination: orders.pagination,
          hasReachedMax:
              orders.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    return emit(
      state.copyWith(
        packagePaginationOrFailureOption: optionOf(result),
        status: result.isRight()
            ? OrderListStatus.success
            : OrderListStatus.failure,
      ),
    );
  }
}
