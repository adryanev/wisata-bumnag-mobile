part of 'register_bloc.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    required NameInput nameInput,
    required EmailInput emailInput,
    required PasswordInput passwordInput,
    required PasswordConfirmationInput passwordConfirmationInput,
    required bool isAgreeToToC,
    required FormzSubmissionStatus formStatus,
    required RegisterStatus status,
    required Option<Either<Failure, Unit>> registerOrFailureOption,
    required Option<Either<Failure, String>> tncOrFailureOption,
    required String tncUrl,
    required bool isValid,
  }) = _RegisterState;
  factory RegisterState.initial() => RegisterState(
        nameInput: const NameInput.pure(),
        emailInput: const EmailInput.pure(),
        passwordInput: const PasswordInput.pure(),
        passwordConfirmationInput: const PasswordConfirmationInput.pure(),
        formStatus: FormzSubmissionStatus.initial,
        status: RegisterStatus.initial,
        registerOrFailureOption: none(),
        isAgreeToToC: false,
        tncOrFailureOption: none(),
        tncUrl: '',
        isValid: false,
      );
}

enum RegisterStatus {
  initial,
  loading,
  success,
  failure,
}
