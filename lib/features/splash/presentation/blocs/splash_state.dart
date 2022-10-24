part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState({
    required Option<Either<Failure, RemoteConfig<String, String>>>
        apiUrlOrFailureOption,
    required Option<Either<Failure, RemoteConfig<String, String>>>
        apiKeyOrFailureOption,
    required Option<Either<Failure, RemoteConfig<String, String>>>
        saltOrFailureOption,
    required Option<Either<Failure, Unit>> saveApiUrlOrFailureOption,
    required Option<Either<Failure, Unit>> saveApiKeyOrFailureOption,
    required Option<Either<Failure, Unit>> saveSaltOrFailureOption,
  }) = _SplashState;
  factory SplashState.initial() => SplashState(
        apiKeyOrFailureOption: none(),
        apiUrlOrFailureOption: none(),
        saltOrFailureOption: none(),
        saveApiKeyOrFailureOption: none(),
        saveApiUrlOrFailureOption: none(),
        saveSaltOrFailureOption: none(),
      );
}
