part of 'destination_detail_bloc.dart';

@freezed
class DestinationDetailState with _$DestinationDetailState {
  const factory DestinationDetailState({
    required bool isLoading,
    required Option<Either<Failure, DestinationDetail>>
        destinationDetailOrFailureOption,
    required DestinationDetail? destinationDetail,
  }) = _DestinationDetailState;
  factory DestinationDetailState.initial() => DestinationDetailState(
        isLoading: false,
        destinationDetailOrFailureOption: none(),
        destinationDetail: null,
      );
}
