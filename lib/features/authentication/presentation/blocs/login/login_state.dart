part of 'login_bloc.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    required LoginStatus status,
    required EmailInput emailInput,
    required PasswordInput passwordInput,
    required Option<Either<Failure, User>> loginOrFailureOption,
    required bool isValid,
    required FormzSubmissionStatus formStatus,
  }) = _LoginState;
  factory LoginState.initial() => LoginState(
        status: LoginStatus.initial,
        emailInput: const EmailInput.pure(),
        passwordInput: const PasswordInput.pure(),
        loginOrFailureOption: none(),
        formStatus: FormzSubmissionStatus.initial,
        isValid: false,
      );
}

enum LoginStatus {
  initial,
  failure,
  success,
  loading,
}
