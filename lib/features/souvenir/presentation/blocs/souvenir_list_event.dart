part of 'souvenir_list_bloc.dart';

@freezed
abstract class SouvenirListEvent with _$SouvenirListEvent {
  const factory SouvenirListEvent.started() = _SouvenirListStarted;
  const factory SouvenirListEvent.refreshed() = _SouvenirListRefreshed;
}
