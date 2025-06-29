part of 'event_list_bloc.dart';

@freezed
abstract class EventListState with _$EventListState {
  const factory EventListState({
    required EventListStatus status,
    required List<Event> events,
    required Option<Either<Failure, Paginable<Event>>>
        eventPaginationOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
    required bool isLoadMore,
  }) = _EventListState;
  factory EventListState.initial() => EventListState(
        status: EventListStatus.initial,
        events: [],
        eventPaginationOrFailureOption: none(),
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

enum EventListStatus { initial, failure, success }
