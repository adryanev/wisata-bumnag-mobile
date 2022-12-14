import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/review/domain/usecases/get_waiting_for_review.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

part 'review_waiting_event.dart';
part 'review_waiting_state.dart';
part 'review_waiting_bloc.freezed.dart';

@injectable
class ReviewWaitingBloc extends Bloc<ReviewWaitingEvent, ReviewWaitingState> {
  ReviewWaitingBloc(this._getWaitingForReview)
      : super(ReviewWaitingState.initial()) {
    on<_ReviewWaitingStarted>(_onStarted);
    on<_ReviewWaitingRefreshed>(_onRefreshed);
  }

  final GetWaitingForReview _getWaitingForReview;
  FutureOr<void> _onStarted(
    _ReviewWaitingStarted event,
    Emitter<ReviewWaitingState> emit,
  ) async {
    if (state.hasReachedMax) return emit(state.copyWith());
    if (state.orderDetails.isEmpty) {
      final result =
          await _getWaitingForReview(const GetWaitingForReviewParams());
      if (result.isRight()) {
        final orderDetail = result.getRight();

        emit(
          state.copyWith(
            orderDetails: orderDetail!.data,
            pagination: orderDetail.pagination,
            hasReachedMax:
                orderDetail.pagination.lastPage == state.pagination.currentPage,
          ),
        );
      }
      return emit(
        state.copyWith(
          orderDetailPaginationOrFailureOption: optionOf(result),
          status:
              result.isRight() ? ReviewWaiting.success : ReviewWaiting.failure,
        ),
      );
    }

    emit(state.copyWith(isLoadMore: true));
    final result = await _getWaitingForReview(
      GetWaitingForReviewParams(
        page: state.pagination.currentPage + 1,
      ),
    );

    if (result.isRight()) {
      final orderDetails = result.getRight();
      emit(
        state.copyWith(
          orderDetails: List.of(state.orderDetails)
            ..addAll(
              orderDetails!.data,
            ),
          pagination: orderDetails.pagination,
          hasReachedMax:
              orderDetails.pagination.lastPage == state.pagination.currentPage,
        ),
      );
    }
    emit(
      state.copyWith(
        orderDetailPaginationOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        orderDetailPaginationOrFailureOption: none(),
        status:
            result.isRight() ? ReviewWaiting.success : ReviewWaiting.failure,
        isLoadMore: false,
      ),
    );
  }

  FutureOr<void> _onRefreshed(
    _ReviewWaitingRefreshed event,
    Emitter<ReviewWaitingState> emit,
  ) {
    emit(ReviewWaitingState.initial());
    add(const ReviewWaitingEvent.started());
  }
}
