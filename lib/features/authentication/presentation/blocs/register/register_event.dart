part of 'register_bloc.dart';

@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.nameInputChanged(String nameString) =
      RegisterNameInputChanged;
  const factory RegisterEvent.emailInputChanged(String emailString) =
      RegisterEmailInputChanged;
  const factory RegisterEvent.passwordInputChanged(String passwordString) =
      RegisterPasswordInputChanged;
  const factory RegisterEvent.confirmPasswordInputChanged(
    String confirmPassword,
  ) = RegisterConfirmPasswordInputChanged;
  const factory RegisterEvent.tocAgreed() = RegisterTocAgreed;
  const factory RegisterEvent.tocDisagreed() = RegisterTocDisaggred;
  const factory RegisterEvent.registerButtonPressed() = RegisterButtonPressed;
}
