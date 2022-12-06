part of 'splash_bloc.dart';

@freezed
class SplashEvent with _$SplashEvent {
  const factory SplashEvent.fetchApiUrl() = _SplashFetchApiUrl;
  const factory SplashEvent.saveApiUrl(RemoteConfig<String, String> config) =
      _SplashSaveApiUrl;
  const factory SplashEvent.fetchApiKey() = _SplashFetchApiKey;
  const factory SplashEvent.saveApiKey(RemoteConfig<String, String> config) =
      _SplashSaveApiKey;
  const factory SplashEvent.fetchSalt() = _SplashFetchSalt;
  const factory SplashEvent.saveSalt(RemoteConfig<String, String> config) =
      _SplashSaveSalt;

  const factory SplashEvent.fetchMapApiKey() = _SplashFetchMapApiKey;
  const factory SplashEvent.saveMapApiKey(RemoteConfig<String, String> config) =
      _SplashSaveMapApiKey;

  const factory SplashEvent.fetchTncUrl() = _SplashFetchTncUrl;
  const factory SplashEvent.saveTncUrl(RemoteConfig<String, String> config) =
      _SplashSaveTncUrl;
}
