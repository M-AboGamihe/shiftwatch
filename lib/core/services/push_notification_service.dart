import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../../features/notifications/presentation/bloc/notification_event.dart';
import '../di/service_locator.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await ServiceLocator.init();
  final body = message.notification?.body ??
      message.data['message']?.toString() ??
      'No message';
  ServiceLocator.notificationBloc.add(AddNotificationEvent(message: body));
}

class PushNotificationService {
  final NotificationBloc _notificationBloc;

  PushNotificationService(this._notificationBloc);

  Future<void> initialize() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (!kIsWeb && Platform.isAndroid && await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel_id',
              'Default',
              channelDescription: 'General notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }

      final body = notification?.body ?? message.data['message']?.toString();
      if (body != null && body.isNotEmpty) {
        _notificationBloc.add(AddNotificationEvent(message: body));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage _) {});
  }
}
