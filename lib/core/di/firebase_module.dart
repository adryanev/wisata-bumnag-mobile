import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/services/remote_config/remote_config_key.dart';

@module
abstract class FirebaseModule {
  @lazySingleton
  @preResolve
  Future<FirebaseRemoteConfig> get remoteConfig async {
    final instance = FirebaseRemoteConfig.instance;
    await instance.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );
    await instance.setDefaults(const <String, dynamic>{
      RemoteConfigKey.apiKey: '',
      RemoteConfigKey.apiUrl: '',
      RemoteConfigKey.salt: '',
      RemoteConfigKey.mapApiKey: '',
    });
    await instance.fetchAndActivate();
    return instance;
  }

  @lazySingleton
  FirebaseMessaging get fcm => FirebaseMessaging.instance;
}
