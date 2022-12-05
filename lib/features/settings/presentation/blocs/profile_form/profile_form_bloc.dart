import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_profile_form.entity.dart';
import 'package:wisatabumnag/features/settings/domain/usecases/get_profile.dart';
import 'package:wisatabumnag/features/settings/domain/usecases/update_avatar.dart';
import 'package:wisatabumnag/features/settings/domain/usecases/update_profile.dart';
import 'package:wisatabumnag/shared/domain/formz/name_input.dart';
import 'package:wisatabumnag/shared/domain/formz/nik_input.dart';
import 'package:wisatabumnag/shared/domain/formz/phone_input.dart';

part 'profile_form_event.dart';
part 'profile_form_state.dart';
part 'profile_form_bloc.freezed.dart';

@injectable
class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  ProfileFormBloc(
    this._getProfile,
    this._updateAvatar,
    this._updateProfile,
    this._imagePicker,
    this._imageCropper,
  ) : super(ProfileFormState.initial()) {
    on<_ProfileFormStarted>(_onStarted);
    on<_ProfileFormNameChanged>(
      _onNameChanged,
      transformer: debounceRestartable(
        duration: _debounceDuration,
      ),
    );
    on<_ProfileFormNikChanged>(
      _onNikChanged,
      transformer: debounceRestartable(
        duration: _debounceDuration,
      ),
    );
    on<_ProfileFormPhoneNumberChanged>(
      _onPhoneNumberChanged,
      transformer: debounceRestartable(
        duration: _debounceDuration,
      ),
    );
    on<_ProfileFormAvatarPressed>(_onAvatarPressed);
    on<_ProfileFormUpdateButtonPressed>(_onUpdatePressed);
  }

  static const _debounceDuration = Duration(milliseconds: 350);
  final GetProfile _getProfile;
  final UpdateAvatar _updateAvatar;
  final UpdateProfile _updateProfile;
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;
  FutureOr<void> _onStarted(
    _ProfileFormStarted event,
    Emitter<ProfileFormState> emit,
  ) async {
    emit(state.copyWith(status: ProfileFormStatus.fetchUser));
    final result = await _getProfile(NoParams());
    if (result.isRight()) {
      final user = result.getRight();
      emit(
        state.copyWith(
          user: user,
          nameInput: NameInput.dirty(user?.name.getOrElse('') ?? ''),
          nikInput: NikInput.dirty(user?.nik?.getOrElse('') ?? ''),
          phoneInput: PhoneInput.dirty(user?.phoneNumber?.getOrElse('') ?? ''),
          avatar: user?.avatar,
        ),
      );
    }
    emit(state.copyWith(fetchProfileOrFailureOption: optionOf(result)));
    emit(
      state.copyWith(
        fetchProfileOrFailureOption: none(),
        status: ProfileFormStatus.initial,
      ),
    );
  }

  FutureOr<void> _onNameChanged(
    _ProfileFormNameChanged event,
    Emitter<ProfileFormState> emit,
  ) {
    emit(
      state.copyWith(
        nameInput: NameInput.dirty(event.nameString),
      ),
    );
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onNikChanged(
    _ProfileFormNikChanged event,
    Emitter<ProfileFormState> emit,
  ) {
    emit(
      state.copyWith(
        nikInput: NikInput.dirty(event.nikString),
      ),
    );
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onPhoneNumberChanged(
    _ProfileFormPhoneNumberChanged event,
    Emitter<ProfileFormState> emit,
  ) {
    emit(
      state.copyWith(
        phoneInput: PhoneInput.dirty(event.phoneNumberString),
      ),
    );
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onAvatarPressed(
    _ProfileFormAvatarPressed event,
    Emitter<ProfileFormState> emit,
  ) async {
    final imagePicked =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imagePicked == null) return;
    final cropped = await _imageCropper.cropImage(sourcePath: imagePicked.path);
    if (cropped == null) return;
    final file = File(cropped.path);
    emit(state.copyWith(status: ProfileFormStatus.updateAvatar));
    final update = await _updateAvatar(UpdateAvatarParams(file));
    if (update.isRight()) {
      emit(
        state.copyWith(
          avatarInput: file,
        ),
      );
    }

    emit(state.copyWith(updateAvatarOrFailureOption: optionOf(update)));
    emit(
      state.copyWith(
        updateAvatarOrFailureOption: none(),
        status: ProfileFormStatus.initial,
      ),
    );
  }

  FutureOr<void> _onUpdatePressed(
    _ProfileFormUpdateButtonPressed event,
    Emitter<ProfileFormState> emit,
  ) async {
    final nameValid = state.nameInput.isValid;
    final nikValid = state.nikInput.isValid;
    final phoneValid = state.phoneInput.isValid;

    if (!nameValid && !nikValid && !phoneValid) {
      return;
    }
    emit(state.copyWith(status: ProfileFormStatus.updateProfile));
    final update = await _updateProfile(
      UpdateProfileParams(
        UpdateProfileForm(
          name: state.nameInput.value,
          nik: state.nikInput.value.isEmpty ? null : state.nikInput.value,
          phoneNumber:
              state.phoneInput.value.isEmpty ? null : state.phoneInput.value,
        ),
      ),
    );
    emit(
      state.copyWith(
        updateProfileOrFailureOption: optionOf(update),
      ),
    );
    emit(
      state.copyWith(
        updateProfileOrFailureOption: none(),
        status: ProfileFormStatus.initial,
      ),
    );
  }

  bool get _isValid =>
      state.nameInput.isValid &&
      state.nikInput.isValid &&
      state.phoneInput.isValid;
}
