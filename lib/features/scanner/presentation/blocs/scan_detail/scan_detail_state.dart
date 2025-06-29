part of 'scan_detail_bloc.dart';

@freezed
abstract class ScanDetailState with _$ScanDetailState {
  const factory ScanDetailState({
    required OrderHistoryItem? orderHistoryItem,
    required bool isLoading,
    required Option<Either<Failure, Unit>> payTicketOrFailureOption,
    required Option<Either<Failure, Unit>> approveTicketOrFailureOption,
    required bool isPaid,
  }) = _ScanDetailState;
  factory ScanDetailState.initial() => ScanDetailState(
        orderHistoryItem: null,
        isLoading: false,
        payTicketOrFailureOption: none(),
        approveTicketOrFailureOption: none(),
        isPaid: false,
      );
}
