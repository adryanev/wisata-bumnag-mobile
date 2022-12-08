part of 'forgot_password_bloc.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    required EmailInput emailInput,
    required Option<Either<Failure, Unit>> forgotOrFailureOption,
    required bool isValid,
    required bool isSubmitting,
  }) = _ForgotPasswordState;

  factory ForgotPasswordState.initial() => ForgotPasswordState(
        emailInput: const EmailInput.pure(),
        forgotOrFailureOption: none(),
        isValid: false,
        isSubmitting: false,
      );
}
