part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required int navigationBarIndex,
  }) = _Homestate;
  factory HomeState.initial() => const HomeState(navigationBarIndex: 0);
}
