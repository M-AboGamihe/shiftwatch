import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'core/di/service_locator.dart';
import 'core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ServiceLocator.init();
  await PushNotificationService(ServiceLocator.notificationBloc).initialize();
  runApp(const ShiftWatchApp());
}
