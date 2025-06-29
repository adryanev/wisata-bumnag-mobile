part of 'event_detail_bloc.dart';

@freezed
abstract class EventDetailState with _$EventDetailState {
  const factory EventDetailState({
    required bool isLoading,
    required Option<Either<Failure, EventDetail>> eventDetailOrFailureOption,
    required EventDetail? eventDetail,
  }) = _EventDetailState;
  factory EventDetailState.initial() => EventDetailState(
        isLoading: false,
        eventDetailOrFailureOption: none(),
        eventDetail: null,
      );
}
