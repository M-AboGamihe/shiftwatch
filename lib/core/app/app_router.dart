import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../../features/notifications/presentation/bloc/notification_state.dart';
import '../../models/app_notification.dart';
import '../../screens/choose_location_screen.dart';
import '../../screens/choose_location_to_edit_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/edit_profile_screen.dart';
import '../../screens/employee_screen.dart';
import '../../screens/employee_setup_screen.dart';
import '../../screens/location_screen.dart';
import '../../screens/location_to_edit_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/notification_screen.dart';
import '../../screens/num_of_location.dart';
import '../../screens/profile_screen.dart';
import '../../screens/setupScreen.dart';
import '../../screens/sign_up_screen.dart';
import '../../screens/splash_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes() {
    return {
      SplashScreen.screenRoute: (_) => const SplashScreen(),
      LoginScreen.screenRoute: (_) => LoginScreen(),
      SignUpScreen.screenRoute: (_) => SignUpScreen(),
      SetupScreen.screenRoute: (_) => SetupScreen(),
      ChooseLocationScreen.screenRoute: (_) => ChooseLocationScreen(),
      LocationScreen.screenRoute: (_) => LocationScreen(),
      EmployeeSetupScreen.screenRoute: (_) => EmployeeSetupScreen(),
      NumOfLocation.screenRoute: (_) => NumOfLocation(),
      ProfileScreen.screenRoute: (_) => ProfileScreen(),
      EditProfileScreen.screenRoute: (_) => EditProfileScreen(),
      DashboardScreen.screenRoute: (_) => DashboardScreen(),
      EmployeeScreen.screenRoute: (context) =>
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) => EmployeeScreen(
              allNotes: state.notifications
                  .map(
                    (n) => AppNotification(
                      message: n.message,
                      timestamp: n.timestamp,
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
      NotificationScreen.screenRoute: (_) => const NotificationScreen(),
      ChooseLocationToEditScreen.screenRoute: (_) => ChooseLocationToEditScreen(),
      LocationToEditScreen.screenRoute: (_) => LocationToEditScreen(),
    };
  }
}
