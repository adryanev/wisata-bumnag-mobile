import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_pasword_form.entity.dart';
import 'package:wisatabumnag/features/settings/domain/usecases/update_password.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
import 'package:wisatabumnag/shared/domain/formz/password_confirmation_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_input.dart';

part 'password_form_event.dart';
part 'password_form_state.dart';
part 'password_form_bloc.freezed.dart';

@injectable
class PasswordFormBloc extends Bloc<PasswordFormEvent, PasswordFormState> {
  PasswordFormBloc(this._updatePassword) : super(PasswordFormState.initial()) {
    on<_PasswordFormOldPasswordChanged>(
      _onOldPasswordChanged,
      transformer: debounceRestartable(
        duration: _debounceDuration,
      ),
    );
    on<_PasswordFormNewPasswordChanged>(
      _onNewPasswordChanged,
      transformer: debounceRestartable(
        duration: _debounceDuration,
      ),
    );
    on<_PasswordFormConfirmPasswordChanged>(
      _onConfirmPasswordChanged,
      transformer: debounceRestartable(
        duration: _debounceDuration,
      ),
    );
    on<_PasswordFormUpdateButtonPressed>(_onUpdatePasswordButton);
  }

  final UpdatePassword _updatePassword;

  static const _debounceDuration = Duration(milliseconds: 350);

  FutureOr<void> _onOldPasswordChanged(
    _PasswordFormOldPasswordChanged event,
    Emitter<PasswordFormState> emit,
  ) {
    emit(
      state.copyWith(
        oldPassword: PasswordInput.dirty(event.oldPasswordString),
      ),
    );
  }

  FutureOr<void> _onNewPasswordChanged(
    _PasswordFormNewPasswordChanged event,
    Emitter<PasswordFormState> emit,
  ) {
    emit(
      state.copyWith(
        newPassword: PasswordInput.dirty(
          event.newPasswordString,
        ),
      ),
    );
  }

  FutureOr<void> _onConfirmPasswordChanged(
    _PasswordFormConfirmPasswordChanged event,
    Emitter<PasswordFormState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: PasswordConfirmationInput.dirty(
          event.passwordConfirmString,
        ),
      ),
    );
  }

  FutureOr<void> _onUpdatePasswordButton(
    _PasswordFormUpdateButtonPressed event,
    Emitter<PasswordFormState> emit,
  ) async {
    final oldPasswordValid = state.oldPassword.isValid;
    final newPasswordValid = state.newPassword.isValid;
    final confirmPasswordValid = state.confirmPassword.isValid;

    if (!oldPasswordValid && !newPasswordValid && !confirmPasswordValid) {
      return;
    }

    final oldPassword = Password(state.oldPassword.value);
    final newPassword = Password(state.newPassword.value);
    final newConfirmPassword = Password(state.confirmPassword.value);

    if (!oldPassword.isValid() &&
        !newPassword.isValid() &&
        !newConfirmPassword.isValid()) {
      return;
    }
    final form = UpdatePasswordForm(
      oldPassword: oldPassword.getOrCrash(),
      password: newPassword.getOrCrash(),
      passwordConfirmation: newConfirmPassword.getOrCrash(),
    );
    emit(state.copyWith(isLoading: true));
    final result = await _updatePassword(
      UpdatePasswordParams(form),
    );
    emit(
      state.copyWith(
        updateOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        updateOrFailureOption: none(),
        isLoading: false,
      ),
    );
  }
}
