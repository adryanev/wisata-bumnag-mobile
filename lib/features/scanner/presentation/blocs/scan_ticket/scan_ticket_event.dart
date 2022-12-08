part of 'scan_ticket_bloc.dart';

@freezed
class ScanTicketEvent with _$ScanTicketEvent {
  const factory ScanTicketEvent.barcodeScaned(String barcodeData) =
      _ScanTicketBarcodeScanned;
}
