part of 'souvenir_list_bloc.dart';

@freezed
class SouvenirListEvent with _$SouvenirListEvent {
  const factory SouvenirListEvent.started() = _SouvenirListStarted;
}
