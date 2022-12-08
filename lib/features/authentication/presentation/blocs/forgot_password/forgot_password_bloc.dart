import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/authentication/domain/usecases/forgot_password.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
import 'package:wisatabumnag/shared/domain/formz/email_input.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';
part 'forgot_password_bloc.freezed.dart';

@injectable
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._forgotPassword)
      : super(ForgotPasswordState.initial()) {
    on<_ForgotPasswordEmailChanged>(
      _onEmailChanged,
      transformer: debounceRestartable(duration: _debounceDuration),
    );
    on<_ForgotPasswordSendPasswordPressed>(_onSendPressed);
  }

  static const _debounceDuration = Duration(milliseconds: 350);
  final ForgotPassword _forgotPassword;

  FutureOr<void> _onEmailChanged(
    _ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(emailInput: EmailInput.dirty(event.emailString)));
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onSendPressed(
    _ForgotPasswordSendPasswordPressed event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (!state.isValid) return;
    final email = EmailAddress(state.emailInput.value);
    if (!email.isValid()) return;
    emit(state.copyWith(isSubmitting: true));
    final result = await _forgotPassword(ForgotPasswordParams(email: email));
    emit(state.copyWith(forgotOrFailureOption: optionOf(result)));
    emit(state.copyWith(forgotOrFailureOption: none(), isSubmitting: false));
  }

  bool get _isValid => state.emailInput.isValid;
}
