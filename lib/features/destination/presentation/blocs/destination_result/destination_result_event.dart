part of 'destination_result_bloc.dart';

@freezed
class DestinationResultEvent with _$DestinationResultEvent {
  const factory DestinationResultEvent.fetched(Category category) =
      DestinationResultFetched;
  const factory DestinationResultEvent.refreshed(Category category) =
      DestinationResultRefreshed;
}
