part of 'authentication_bloc.dart';

@freezed
abstract class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.checkAuthenticationStatus() =
      AuthenticationCheckAuthenticationStatus;
  const factory AuthenticationEvent.loggedOut() = AuthenticationLoggedOut;
}
