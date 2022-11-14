part of 'splash_bloc.dart';

@freezed
class SplashEvent with _$SplashEvent {
  const factory SplashEvent.fetchApiUrl() = SplashFetchApiUrl;
  const factory SplashEvent.saveApiUrl(RemoteConfig<String, String> config) =
      SplashSaveApiUrl;
  const factory SplashEvent.fetchApiKey() = SplashFetchApiKey;
  const factory SplashEvent.saveApiKey(RemoteConfig<String, String> config) =
      SplashSaveApiKey;
  const factory SplashEvent.fetchSalt() = SplashFetchSalt;
  const factory SplashEvent.saveSalt(RemoteConfig<String, String> config) =
      SplashSaveSalt;

  const factory SplashEvent.fetchMapApiKey() = SplashFetchMapApiKey;
  const factory SplashEvent.saveMapApiKey(RemoteConfig<String, String> config) =
      SplashSaveMapApiKey;
}
