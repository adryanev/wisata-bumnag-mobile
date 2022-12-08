part of 'souvenir_detail_bloc.dart';

@freezed
class SouvenirDetailEvent with _$SouvenirDetailEvent {
  const factory SouvenirDetailEvent.started(int souvenirId) =
      _SouveniDetailStarted;
}
