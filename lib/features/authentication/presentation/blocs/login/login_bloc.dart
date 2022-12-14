import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/login/login_form.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/usecases/login_user.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
import 'package:wisatabumnag/shared/domain/formz/email_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_input.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUser) : super(LoginState.initial()) {
    on<_LoginEmailInputChanged>(
      _loginEmailChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<_LoginPasswordInputChanged>(
      _passwordInputChanged,
      transformer: debounceRestartable(
        duration: _debounceDuration,
      ),
    );
    on<_LoginButtonPressed>(_loginButtonPressed);
  }
  static const _debounceDuration = Duration(milliseconds: 350);

  final LoginUser _loginUser;

  FutureOr<void> _loginEmailChanged(
    _LoginEmailInputChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        emailInput: EmailInput.dirty(event.emailString),
      ),
    );
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _passwordInputChanged(
    _LoginPasswordInputChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        passwordInput: PasswordInput.dirty(event.passwordString),
      ),
    );
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _loginButtonPressed(
    _LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) {
      return;
    }

    final emailAddress = EmailAddress(state.emailInput.value);
    final password = Password(state.passwordInput.value);
    if (!emailAddress.isValid() && !password.isValid()) {
      return;
    }
    final form = LoginForm(emailAddress: emailAddress, password: password);
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _loginUser(
      LoginUserParams(loginForm: form),
    );
    emit(
      state.copyWith(
        loginOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        loginOrFailureOption: none(),
        status: LoginStatus.initial,
      ),
    );
  }

  bool get _isValid => state.emailInput.isValid && state.passwordInput.isValid;
}
