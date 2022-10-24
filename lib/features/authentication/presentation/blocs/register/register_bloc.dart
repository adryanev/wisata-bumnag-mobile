import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/register/register_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/usecases/register_user.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
import 'package:wisatabumnag/shared/domain/formz/email_input.dart';
import 'package:wisatabumnag/shared/domain/formz/name_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_confirmation_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_input.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._registerUser) : super(RegisterState.initial()) {
    on<RegisterNameInputChanged>(
      _registerNameInputChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<RegisterEmailInputChanged>(
      _emailNameInputChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<RegisterPasswordInputChanged>(
      _passwordInputChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<RegisterConfirmPasswordInputChanged>(
      _confirmPasswordChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<RegisterTocAgreed>(_onTocAgreed);
    on<RegisterTocDisaggred>(_onTocDisagreed);
    on<RegisterButtonPressed>(_registerButtonPressed);
  }
  static const _debounceDuration = Duration(milliseconds: 350);

  final RegisterUser _registerUser;
  FutureOr<void> _registerNameInputChanged(
    RegisterNameInputChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        nameInput: NameInput.dirty(event.nameString),
      ),
    );
  }

  FutureOr<void> _emailNameInputChanged(
    RegisterEmailInputChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(emailInput: EmailInput.dirty(event.emailString)));
  }

  FutureOr<void> _passwordInputChanged(
    RegisterPasswordInputChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(passwordInput: PasswordInput.dirty(event.passwordString)),
    );
  }

  FutureOr<void> _confirmPasswordChanged(
    RegisterConfirmPasswordInputChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        passwordConfirmationInput: PasswordConfirmationInput.dirty(
          state.passwordInput.value,
          event.confirmPassword,
        ),
      ),
    );
  }

  FutureOr<void> _onTocAgreed(
    RegisterTocAgreed event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(isAgreeToToC: true),
    );
  }

  FutureOr<void> _onTocDisagreed(
    RegisterTocDisaggred event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(isAgreeToToC: false),
    );
  }

  FutureOr<void> _registerButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    if (!validateRequiredInput()) {
      return;
    }
    final email = EmailAddress(state.emailInput.value);
    final password = Password(state.passwordInput.value);
    final name = StringSingleLine(state.nameInput.value);

    if (!email.isValid() && !password.isValid() && !name.isValid()) {
      return;
    }

    final form =
        RegisterForm(emailAddress: email, password: password, fullName: name);

    emit(
      state.copyWith(
        status: RegisterStatus.loading,
        formStatus: FormzSubmissionStatus.inProgress,
      ),
    );

    final result = await _registerUser(RegisterUserParams(registerForm: form));
    result.fold(
      (l) => emit(
        state.copyWith(
          status: RegisterStatus.failure,
          formStatus: FormzSubmissionStatus.failure,
        ),
      ),
      (r) => emit(
        state.copyWith(
          formStatus: FormzSubmissionStatus.success,
          status: RegisterStatus.success,
        ),
      ),
    );
    emit(state.copyWith(registerOrFailureOption: optionOf(result)));
    emit(state.copyWith(registerOrFailureOption: none()));
  }

  bool validateRequiredInput() {
    if (state.emailInput.isNotValid) {
      return false;
    }
    if (state.nameInput.isNotValid) {
      return false;
    }
    if (state.passwordInput.isNotValid) {
      return false;
    }
    if (state.passwordConfirmationInput.isNotValid) {
      return false;
    }

    return true;
  }
}
