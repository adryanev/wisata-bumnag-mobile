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
}

enum MessageType {
  info,
  warning,
  success,
  danger,
}

class LocalStorageKey {
  const LocalStorageKey._();
  static const apiKeyKey = 'apiKey';
  static const userKey = 'user';
  static const accessTokenKey = 'access-token';
  static const refreshTokenKey = 'refresh-token';
  static const saltKey = 'salt';
  static const baseUrlKey = 'base-url';
}

class InjectionConstants {
  const InjectionConstants._();
  static const publicDio = 'public_dio';
}
