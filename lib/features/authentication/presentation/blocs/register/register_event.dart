part of 'register_bloc.dart';

@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.started() = _RegisterStarted;
  const factory RegisterEvent.nameInputChanged(String nameString) =
      _RegisterNameInputChanged;
  const factory RegisterEvent.emailInputChanged(String emailString) =
      _RegisterEmailInputChanged;
  const factory RegisterEvent.passwordInputChanged(String passwordString) =
      _RegisterPasswordInputChanged;
  const factory RegisterEvent.confirmPasswordInputChanged(
    String confirmPassword,
  ) = _RegisterConfirmPasswordInputChanged;
  const factory RegisterEvent.tocAgreed() = _RegisterTocAgreed;
  const factory RegisterEvent.tocDisagreed() = _RegisterTocDisaggred;
  const factory RegisterEvent.registerButtonPressed() = _RegisterButtonPressed;
}
