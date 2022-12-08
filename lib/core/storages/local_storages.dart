import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/authentication/data/models/user_local_model.model.dart';
import 'package:wisatabumnag/features/cart/data/models/cart_souvenir_model.model.dart';

abstract class LocalStorage {
  Future<String?> getApiKey();
  Future<void> setApiKey(String apiKey);

  Future<String?> getSalt();
  Future<void> setSalt(String salt);

  Future<UserLocalModel?> getLoggedInUser();
  Future<void> setLoggedIn(UserLocalModel user);

  Future<String?> getAccessToken();
  Future<void> setAccessToken(String accessToken);

  Future<String?> getBaseUrl();
  Future<void> setBaseUrl(String baseUrl);

  Future<String?> getMapApiKey();
  Future<void> setMapApiKey(String mapApiKey);

  Future<void> logoutUser();

  Future<void> saveCart(List<CartSouvenirModel> carts);
  Future<List<CartSouvenirModel>?> getUserCart();

  Future<void> saveFcmToken(String fcmToken);
  Future<String?> getFcmToken();

  Future<void> saveTncUrl(String tncUrl);
  Future<String?> getTnC();
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
  Future<void> setApiKey(String apiKey) {
    return _storage.setString(LocalStorageKey.apiKeyKey, apiKey);
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
  Future<String?> getBaseUrl() {
    return Future.value(
      _storage.getString(LocalStorageKey.baseUrlKey),
    );
  }

  @override
  Future<void> setAccessToken(String accessToken) {
    return _storage.setString(LocalStorageKey.accessTokenKey, accessToken);
  }

  @override
  Future<void> setLoggedIn(UserLocalModel user) async {
    final data = jsonEncode(user);
    await _storage.setString(LocalStorageKey.userKey, data);
  }

  @override
  Future<void> setBaseUrl(String baseUrl) {
    return _storage.setString(LocalStorageKey.baseUrlKey, baseUrl);
  }

  @override
  Future<void> logoutUser() async {
    await Future.wait([
      _storage.remove(LocalStorageKey.accessTokenKey),
      _storage.remove(LocalStorageKey.userKey),
    ]);
  }

  @override
  Future<String?> getSalt() {
    return Future.value(
      _storage.getString(LocalStorageKey.saltKey),
    );
  }

  @override
  Future<void> setSalt(String salt) {
    return _storage.setString(LocalStorageKey.saltKey, salt);
  }

  @override
  Future<String?> getMapApiKey() {
    return Future.value(_storage.getString(LocalStorageKey.mapApiKey));
  }

  @override
  Future<void> setMapApiKey(String mapApiKey) {
    return _storage.setString(LocalStorageKey.mapApiKey, mapApiKey);
  }

  @override
  Future<List<CartSouvenirModel>?> getUserCart() {
    final data = _storage.getString(LocalStorageKey.cartKey);
    if (data == null) return Future.value();
    final carts = jsonDecode(data) as List<dynamic>;
    final cartsObject = carts
        .map((x) => CartSouvenirModel.fromJson(x as Map<String, dynamic>))
        .toList();

    return Future.value(cartsObject);
  }

  @override
  Future<void> saveCart(List<CartSouvenirModel> carts) {
    final data = jsonEncode(carts);
    return _storage.setString(LocalStorageKey.cartKey, data);
  }

  @override
  Future<String?> getFcmToken() {
    return Future.value(_storage.getString(LocalStorageKey.fcmTokenKey));
  }

  @override
  Future<void> saveFcmToken(String fcmToken) {
    return _storage.setString(LocalStorageKey.fcmTokenKey, fcmToken);
  }

  @override
  Future<String?> getTnC() {
    return Future.value(_storage.getString(LocalStorageKey.tncUrl));
  }

  @override
  Future<void> saveTncUrl(String tncUrl) {
    return _storage.setString(LocalStorageKey.tncUrl, tncUrl);
  }
}
