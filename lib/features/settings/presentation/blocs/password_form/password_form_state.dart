part of 'password_form_bloc.dart';

@freezed
abstract class PasswordFormState with _$PasswordFormState {
  const factory PasswordFormState({
    required bool isLoading,
    required PasswordInput oldPassword,
    required PasswordInput newPassword,
    required PasswordConfirmationInput confirmPassword,
    required Option<Either<Failure, Unit>> updateOrFailureOption,
    required FormzSubmissionStatus formStatus,
    required bool isValid,
  }) = _PasswordFormState;
  factory PasswordFormState.initial() => PasswordFormState(
        isLoading: false,
        oldPassword: const PasswordInput.pure(),
        newPassword: const PasswordInput.pure(),
        confirmPassword: const PasswordConfirmationInput.pure(),
        updateOrFailureOption: none(),
        formStatus: FormzSubmissionStatus.initial,
        isValid: false,
      );
}
