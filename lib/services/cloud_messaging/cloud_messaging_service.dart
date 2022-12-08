// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/features/authentication/data/datasources/remote/client/refresh_token_api_client.dart';
import 'package:wisatabumnag/injector.dart';

@lazySingleton
class CloudMessagingService {
  static final FlutterLocalNotificationsPlugin localNotification =
      getIt<FlutterLocalNotificationsPlugin>();
  static final FirebaseMessaging fcm = getIt<FirebaseMessaging>();
  static final localStorage = getIt<LocalStorage>();
  static final RefreshTokenApiClient _client = getIt<RefreshTokenApiClient>();

  static Future<void> listenNotification() async {
    const initializeAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializeIOSSettings = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    const initializationSettings = InitializationSettings(
      android: initializeAndroidSettings,
      iOS: initializeIOSSettings,
    );
    await localNotification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onNotificationResponse,
    );

    if (Platform.isIOS) {
      final settings = await fcm.requestPermission(
        provisional: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('User granted provisional permission');
      } else {
        log('User declined or has not accepted permission');
      }
    }

    final token = await fcm.getToken();

    if (token != null) {
      log('fcmToken: $token');
      await localStorage.saveFcmToken(token);
      //update fcm token if logged in
      final jwt = await localStorage.getAccessToken();
      if (jwt != null) {
        //send data fcm to server
        try {
          await _client.updateFcm(token);
        } catch (e, st) {
          log(e.toString(), stackTrace: st);
        }
      }
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(
        'FirebaseMessage received: $message with data ${message.notification}',
      );
      showNotification(message);
      // mapAndShowNotification(message);
    });
  }

  static Future<void> _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    log('Fcm notification clicked: $payload');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print('Handling fcm background message: ${message.messageId}');
    }
    await mapAndShowNotification(message.data);
  }

  static Future<String?> _handleOnMessage(Map<String, dynamic> message) async {
    try {
      if (Platform.isAndroid) {
        log('>> Message : $message');
        if (message['data']?['action'] != null &&
            message['data']?['action'] != 'no') {
          final url = message['data']['action'] as String;
          return url;
        } else {
          return null;
        }
      } else if (Platform.isIOS) {
        if (message['action'] != null && message['action'] != 'no') {
          final url = message['action'] as String;
          return url;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      return null;
    }
  }

  static Future<void> mapAndShowNotification(
    Map<String, dynamic> message,
  ) async {
    log('handle show notification : $message');
    final title = '${message['notification']['title']}';
    final body = "${message['notification']['body']}";
    await localNotification.show(
      math.Random().nextInt(900) + 100,
      title,
      body,
      await _setupFcmNotification(),
      payload: json.encode(message),
    );
  }

  static Future<NotificationDetails> _setupFcmNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'wisata_bumnag_notification',
      'wisata_bumnag_notification',
      channelDescription: 'wisata_bumnag_notification',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    return platformChannelSpecifics;
  }

  static Future<void> showNotification(RemoteMessage? message) async {
    log('handle show notification : $message');
    await localNotification.show(
      math.Random().nextInt(900) + 100,
      message?.notification?.title,
      message?.notification?.body,
      await _setupFcmNotification(),
    );
  }

  static Future<void> _onNotificationResponse(
    NotificationResponse details,
  ) async {
    final payload = details.payload;
    log('Handling selectNotificatione: $payload');
    if (payload != null) {
      final parsedPayload = json.decode(payload) as Map<String, dynamic>;
      //handle click event from payload
      await _handleOnMessage(parsedPayload);
    }
  }
}
