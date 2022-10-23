import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/utils/utils.dart';
import 'package:wisatabumnag/services/remote_config/remote_config_key.dart';

abstract class RemoteConfigService {
  Future<String?> getBaseUrl();
  Future<String?> getApiKey();
  Future<String?> getSalt();
}

@LazySingleton(as: RemoteConfigService)
class RemoteConfigServiceImpl implements RemoteConfigService {
  const RemoteConfigServiceImpl(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;
  @override
  Future<String?> getApiKey() async => safeCall(
        tryCallback: () async {
          await _remoteConfig.activate();
          return _remoteConfig.getString(RemoteConfigKey.apiKey);
        },
        exceptionCallBack: () {
          return null;
        },
      );

  @override
  Future<String?> getBaseUrl() async => safeCall(
        tryCallback: () async {
          await _remoteConfig.activate();
          return _remoteConfig.getString(RemoteConfigKey.apiUrl);
        },
        exceptionCallBack: () {
          return null;
        },
      );

  @override
  Future<String?> getSalt() async => safeCall(
        tryCallback: () async {
          await _remoteConfig.activate();
          return _remoteConfig.getString(RemoteConfigKey.salt);
        },
        exceptionCallBack: () {
          return null;
        },
      );
}
