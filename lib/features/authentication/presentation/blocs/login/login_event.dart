part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.emailInputChanged(String emailString) =
      LoginEmailInputChanged;
  const factory LoginEvent.passwordInputChanged(String passwordString) =
      LoginPasswordInputChanged;

  const factory LoginEvent.loginButtonPressed() = LoginButtonPressed;
}
