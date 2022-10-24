import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/usecases/get_logged_in_user.dart';
import 'package:wisatabumnag/features/authentication/domain/usecases/logout_user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';
part 'authentication_bloc.freezed.dart';

@lazySingleton
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._getLoggedInUser, this._logoutUser)
      : super(const AuthenticationState.initial()) {
    on<AuthenticationCheckAuthenticationStatus>(_checkAuthenticationStatus);
    on<AuthenticationLoggedOut>(_logOut);
  }
  final GetLoggedInUser _getLoggedInUser;
  final LogoutUser _logoutUser;

  FutureOr<void> _checkAuthenticationStatus(
    AuthenticationCheckAuthenticationStatus event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.initial());
    final result = await _getLoggedInUser(NoParams());
    result.fold((l) => emit(AuthenticationState.failed(l)), (r) {
      if (r == null) {
        emit(const AuthenticationState.unauthenticated());
      } else {
        emit(
          AuthenticationState.authenticated(r),
        );
      }
    });
  }

  FutureOr<void> _logOut(
    AuthenticationLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    final result = await _logoutUser(NoParams());
    result.fold(
      (l) => emit(AuthenticationState.failed(l)),
      (r) => emit(
        const AuthenticationState.unauthenticated(),
      ),
    );
  }
}
