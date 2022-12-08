import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/register/register_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/usecases/get_tnc.dart';
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
  RegisterBloc(this._registerUser, this._getTnc)
      : super(RegisterState.initial()) {
    on<_RegisterStarted>(_onStarted);

    on<_RegisterNameInputChanged>(
      _registerNameInputChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<_RegisterEmailInputChanged>(
      _emailNameInputChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<_RegisterPasswordInputChanged>(
      _passwordInputChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<_RegisterConfirmPasswordInputChanged>(
      _confirmPasswordChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<_RegisterTocAgreed>(_onTocAgreed);
    on<_RegisterTocDisaggred>(_onTocDisagreed);
    on<_RegisterButtonPressed>(_registerButtonPressed);
  }
  static const _debounceDuration = Duration(milliseconds: 350);

  final RegisterUser _registerUser;
  final GetTnc _getTnc;

  FutureOr<void> _registerNameInputChanged(
    _RegisterNameInputChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        nameInput: NameInput.dirty(event.nameString),
      ),
    );
    emit(state.copyWith(isValid: validateRequiredInput()));
  }

  FutureOr<void> _emailNameInputChanged(
    _RegisterEmailInputChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(emailInput: EmailInput.dirty(event.emailString)));
    emit(state.copyWith(isValid: validateRequiredInput()));
  }

  FutureOr<void> _passwordInputChanged(
    _RegisterPasswordInputChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(passwordInput: PasswordInput.dirty(event.passwordString)),
    );
    emit(state.copyWith(isValid: validateRequiredInput()));
  }

  FutureOr<void> _confirmPasswordChanged(
    _RegisterConfirmPasswordInputChanged event,
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
    emit(state.copyWith(isValid: validateRequiredInput()));
  }

  FutureOr<void> _onTocAgreed(
    _RegisterTocAgreed event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(isAgreeToToC: true),
    );
    emit(state.copyWith(isValid: validateRequiredInput()));
  }

  FutureOr<void> _onTocDisagreed(
    _RegisterTocDisaggred event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(isAgreeToToC: false),
    );
    emit(state.copyWith(isValid: validateRequiredInput()));
  }

  FutureOr<void> _registerButtonPressed(
    _RegisterButtonPressed event,
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

  FutureOr<void> _onStarted(
    _RegisterStarted event,
    Emitter<RegisterState> emit,
  ) async {
    final tnc = await _getTnc(NoParams());
    emit(
      state.copyWith(
        tncOrFailureOption: optionOf(tnc),
      ),
    );
    emit(
      state.copyWith(
        tncOrFailureOption: none(),
        tncUrl: tnc.getOrElse(
          () => '',
        ),
      ),
    );
  }
}
