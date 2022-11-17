part of 'souvenir_list_bloc.dart';

@freezed
class SouvenirListState with _$SouvenirListState {
  const factory SouvenirListState({
    required SouvenirListStatus status,
    required List<DestinationSouvenir> souvenirs,
    required Option<Either<Failure, Paginable<DestinationSouvenir>>>
        souvenirsPaginationOrFailureOption,
    required bool hasReachedMax,
    required int currentPage,
    required Pagination pagination,
  }) = _SouvenirListState;
  factory SouvenirListState.initial() => SouvenirListState(
        status: SouvenirListStatus.initial,
        souvenirs: [],
        souvenirsPaginationOrFailureOption: none(),
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

enum SouvenirListStatus { initial, failure, success }
