part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.bottomNavigatonChanged(int value) =
      HomeBottomNavigationChaged;
}
