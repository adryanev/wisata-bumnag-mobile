import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/services/remote_config/remote_config_key.dart';

abstract class FirebaseModule {
  @lazySingleton
  @preResolve
  Future<FirebaseRemoteConfig> get remoteConfig async {
    final instance = FirebaseRemoteConfig.instance;
    await instance.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 5),
      ),
    );
    await instance.setDefaults(const <String, dynamic>{
      RemoteConfigKey.apiKey: '',
      RemoteConfigKey.apiUrl: '',
      RemoteConfigKey.salt: '',
    });
    await instance.fetchAndActivate();
    return instance;
  }
}
