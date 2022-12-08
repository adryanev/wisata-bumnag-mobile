part of 'scan_ticket_bloc.dart';

@freezed
class ScanTicketState with _$ScanTicketState {
  const factory ScanTicketState({
    required bool isLoading,
    required Option<Either<Failure, OrderHistoryItem>> checkedOrFailureOption,
  }) = _ScanTicketState;
  factory ScanTicketState.initial() => ScanTicketState(
        isLoading: false,
        checkedOrFailureOption: none(),
      );
}
