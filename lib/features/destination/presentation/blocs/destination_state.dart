part of 'destination_bloc.dart';

@freezed
class DestinationState with _$DestinationState {
  const factory DestinationState({
    required bool isCategoryLoading,
    required Option<Either<Failure, List<Category>>> categoriesOrFailureOption,
    List<Category>? categories,
  }) = _DestinationState;

  factory DestinationState.initial() => DestinationState(
        isCategoryLoading: false,
        categoriesOrFailureOption: none(),
      );
}
