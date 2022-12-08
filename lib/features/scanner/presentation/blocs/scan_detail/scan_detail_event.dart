part of 'scan_detail_bloc.dart';

@freezed
class ScanDetailEvent with _$ScanDetailEvent {
  const factory ScanDetailEvent.started(OrderHistoryItem orderHistoryItem) =
      _ScanDetailStarted;
  const factory ScanDetailEvent.payNowButtonPressed() =
      _ScanDetailPayNowButtonPressed;
  const factory ScanDetailEvent.approveButtonPressed() =
      _ScanDetailApproveButtonPressed;
}
