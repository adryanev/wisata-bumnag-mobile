part of 'authentication_bloc.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = AuthenticationInitial;
  const factory AuthenticationState.unauthenticated() =
      AuthenticationUnauthenticated;
  const factory AuthenticationState.authenticated(User user) =
      AuthenticationAuthenticated;
  const factory AuthenticationState.failed(Failure failure) =
      AuthenticationFailed;
}
