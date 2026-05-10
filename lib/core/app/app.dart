import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../../features/notifications/presentation/bloc/notification_event.dart';
import '../di/service_locator.dart';
import 'app_router.dart';
import '../../screens/splash_screen.dart';

class ShiftWatchApp extends StatelessWidget {
  const ShiftWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>.value(
      value: ServiceLocator.notificationBloc..add(LoadNotificationsEvent()),
      child: MaterialApp(
        title: 'ShiftWatchApp',
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.screenRoute,
        routes: AppRouter.routes(),
      ),
    );
  }
}
