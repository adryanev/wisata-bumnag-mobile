part of 'event_list_bloc.dart';

@freezed
class EventListState with _$EventListState {
  const factory EventListState({
    required EventListStatus status,
    required List<Event> events,
    required Option<Either<Failure, Paginable<Event>>>
        packagePaginationOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
  }) = _EventListState;
  factory EventListState.initial() => EventListState(
        status: EventListStatus.initial,
        events: [],
        packagePaginationOrFailureOption: none(),
        hasReachedMax: false,
        currentPage: 1,
        pagination: const Pagination(
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: 0,
        ),
      );
}

enum EventListStatus { initial, failure, success }
