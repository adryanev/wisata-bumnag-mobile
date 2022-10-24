part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required LoginStatus status,
    required EmailInput emailInput,
    required PasswordInput passwordInput,
    required Option<Either<Failure, User>> loginOrFailureOption,
    required FormzSubmissionStatus formStatus,
  }) = _LoginState;
  factory LoginState.initial() => LoginState(
        status: LoginStatus.initial,
        emailInput: const EmailInput.pure(),
        passwordInput: const PasswordInput.pure(),
        loginOrFailureOption: none(),
        formStatus: FormzSubmissionStatus.initial,
      );
}

enum LoginStatus {
  initial,
  failure,
  success,
  loading,
}
