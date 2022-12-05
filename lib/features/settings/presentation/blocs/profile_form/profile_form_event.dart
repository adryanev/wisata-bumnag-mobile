part of 'profile_form_bloc.dart';

@freezed
class ProfileFormEvent with _$ProfileFormEvent {
  const factory ProfileFormEvent.started() = _ProfileFormStarted;
  const factory ProfileFormEvent.nameChanged(String nameString) =
      _ProfileFormNameChanged;
  const factory ProfileFormEvent.nikChanged(String nikString) =
      _ProfileFormNikChanged;
  const factory ProfileFormEvent.phoneNumberChanged(String phoneNumberString) =
      _ProfileFormPhoneNumberChanged;

  const factory ProfileFormEvent.avatarPressed() = _ProfileFormAvatarPressed;
  const factory ProfileFormEvent.updateButtonPressed() =
      _ProfileFormUpdateButtonPressed;
}
