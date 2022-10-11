import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/authentication/data/models/user_local_model.model.dart';

abstract class LocalStorage {
  Future<String?> getApiKey();
  Future<void> setApiKey(String apiKey);

  Future<UserLocalModel?> getLoggedInUser();
  Future<void> setLoggedIn(UserLocalModel user);

  Future<String?> getAccessToken();
  Future<void> setAccessToken(String accessToken);

  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String refreshToken);

  Future<void> logoutUser();
}

@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  const LocalStorageImpl(this._storage);
  final SharedPreferences _storage;

  @override
  Future<String?> getApiKey() {
    return Future.value(
      _storage.getString(LocalStorageKey.apiKeyKey),
    );
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    await Future.value(
      _storage.setString(LocalStorageKey.apiKeyKey, apiKey),
    );
  }

  @override
  Future<String?> getAccessToken() {
    return Future.value(
      _storage.getString(LocalStorageKey.accessTokenKey),
    );
  }

  @override
  Future<UserLocalModel?> getLoggedInUser() {
    final data = _storage.getString(LocalStorageKey.userKey);
    if (data == null) {
      return Future.value();
    }
    final user =
        UserLocalModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
    return Future.value(user);
  }

  @override
  Future<String?> getRefreshToken() {
    return Future.value(
      _storage.getString(LocalStorageKey.refreshTokenKey),
    );
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _storage.setString(LocalStorageKey.accessTokenKey, accessToken);
  }

  @override
  Future<void> setLoggedIn(UserLocalModel user) async {
    final data = jsonEncode(user);
    await _storage.setString(LocalStorageKey.userKey, data);
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    await _storage.setString(LocalStorageKey.refreshTokenKey, refreshToken);
  }

  @override
  Future<void> logoutUser() async {
    await Future.wait([
      _storage.remove(LocalStorageKey.accessTokenKey),
      _storage.remove(LocalStorageKey.refreshTokenKey),
      _storage.remove(LocalStorageKey.userKey),
    ]);
  }
}
