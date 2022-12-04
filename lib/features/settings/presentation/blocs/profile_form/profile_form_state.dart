part of 'profile_form_bloc.dart';

@freezed
class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required bool isLoading,
    required NameInput nameInput,
    required User? user,
    required NikInput nikInput,
    required PhoneInput phoneInput,
    required File? avatarInput,
    required Option<Either<Failure, Unit>> updateProfileOrFailureOption,
    required Option<Either<Failure, Unit>> updateAvatarOrFailureOption,
  }) = _ProfileFormState;
  factory ProfileFormState.initial() => ProfileFormState(
        isLoading: false,
        nameInput: const NameInput.pure(),
        user: null,
        nikInput: const NikInput.pure(),
        phoneInput: const PhoneInput.pure(),
        avatarInput: null,
        updateProfileOrFailureOption: none(),
        updateAvatarOrFailureOption: none(),
      );
}
