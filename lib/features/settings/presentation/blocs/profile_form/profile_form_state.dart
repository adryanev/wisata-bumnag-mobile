part of 'profile_form_bloc.dart';

@freezed
abstract class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required ProfileFormStatus status,
    required NameInput nameInput,
    required User? user,
    required NikInput nikInput,
    required PhoneInput phoneInput,
    required File? avatarInput,
    required String? avatar,
    required Option<Either<Failure, Unit>> updateProfileOrFailureOption,
    required Option<Either<Failure, Unit>> updateAvatarOrFailureOption,
    required Option<Either<Failure, User>> fetchProfileOrFailureOption,
    required bool isValid,
  }) = _ProfileFormState;
  factory ProfileFormState.initial() => ProfileFormState(
        status: ProfileFormStatus.initial,
        nameInput: const NameInput.pure(),
        user: null,
        nikInput: const NikInput.pure(),
        phoneInput: const PhoneInput.pure(),
        avatarInput: null,
        updateProfileOrFailureOption: none(),
        updateAvatarOrFailureOption: none(),
        fetchProfileOrFailureOption: none(),
        avatar: null,
        isValid: false,
      );
}

enum ProfileFormStatus {
  initial,
  fetchUser,
  updateAvatar,
  updateProfile,
}
