part of 'souvenir_detail_bloc.dart';

@freezed
class SouvenirDetailState with _$SouvenirDetailState {
  const factory SouvenirDetailState({
    required bool isLoading,
    required Option<Either<Failure, SouvenirDetail>>
        souvenirDetailOrFailureOption,
    required SouvenirDetail? souvenirDetail,
  }) = _SouvenirDetailState;
  factory SouvenirDetailState.initial() => SouvenirDetailState(
        isLoading: false,
        souvenirDetailOrFailureOption: none(),
        souvenirDetail: null,
      );
}
