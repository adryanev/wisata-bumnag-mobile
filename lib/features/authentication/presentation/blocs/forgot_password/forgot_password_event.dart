part of 'forgot_password_bloc.dart';

@freezed
abstract class ForgotPasswordEvent with _$ForgotPasswordEvent {
  const factory ForgotPasswordEvent.emailChanged(String emailString) =
      _ForgotPasswordEmailChanged;
  const factory ForgotPasswordEvent.sendButtonPressed() =
      _ForgotPasswordSendPasswordPressed;
}
