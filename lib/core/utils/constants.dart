import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Environment {
  const Environment._();
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';
  static const String test = 'test';
}

class ScreenUtilSize {
  const ScreenUtilSize._();
  static const double width = 375;
  static const double height = 897;
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class DateTimeFormat {
  const DateTimeFormat._();
  static DateFormat get dayString => DateFormat.EEEE();
  static DateFormat get monthAbbrWithDate => DateFormat.MMMMd();
  static DateFormat get hourMinutes => DateFormat.Hm();
  static DateFormat get standard => DateFormat('dd MMM yyyy', 'id');
  static DateFormat get completeDateWithDay => DateFormat.yMMMMEEEEd('id');
}

enum MessageType {
  info,
  warning,
  success,
  danger,
}

class LocalStorageKey {
  const LocalStorageKey._();
  static const apiKeyKey = 'api_key';
  static const userKey = 'user';
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const saltKey = 'salt';
  static const baseUrlKey = 'base_url';
  static const mapApiKey = 'map_api_key';
  static const cartKey = 'cart';
}

class InjectionConstants {
  const InjectionConstants._();
  static const publicDio = 'public_dio';
  static const privateDio = 'private_dio';
}
