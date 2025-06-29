part of 'login_bloc.dart';

@freezed
abstract class LoginEvent with _$LoginEvent {
  const factory LoginEvent.emailInputChanged(String emailString) =
      _LoginEmailInputChanged;
  const factory LoginEvent.passwordInputChanged(String passwordString) =
      _LoginPasswordInputChanged;

  const factory LoginEvent.loginButtonPressed() = _LoginButtonPressed;
}
