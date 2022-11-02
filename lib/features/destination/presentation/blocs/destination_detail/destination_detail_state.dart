part of 'destination_detail_bloc.dart';

@freezed
class DestinationDetailState with _$DestinationDetailState {
  const factory DestinationDetailState({
    required Option<Either<Failure, DestinationDetail>>
        destinationDetailOrFailureOption,
    required DestinationDetail? destinationDetail,
  }) = _DestinationDetailState;
  factory DestinationDetailState.initial() => DestinationDetailState(
        destinationDetailOrFailureOption: none(),
        destinationDetail: null,
      );
}
