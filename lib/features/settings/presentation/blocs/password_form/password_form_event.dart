part of 'password_form_bloc.dart';

@freezed
abstract class PasswordFormEvent with _$PasswordFormEvent {
  const factory PasswordFormEvent.oldPasswordChanged(String oldPasswordString) =
      _PasswordFormOldPasswordChanged;
  const factory PasswordFormEvent.newPasswordChanged(String newPasswordString) =
      _PasswordFormNewPasswordChanged;

  const factory PasswordFormEvent.confirmationPasswordChanged(
    String passwordConfirmString,
  ) = _PasswordFormConfirmPasswordChanged;

  const factory PasswordFormEvent.updateButtonPressed() =
      _PasswordFormUpdateButtonPressed;
}
