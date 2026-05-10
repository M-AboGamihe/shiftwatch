import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_info.dart';
import '../../features/employees/data/datasources/employees_remote_data_source.dart';
import '../../features/employees/data/repositories/employees_repository_impl.dart';
import '../../features/employees/domain/usecases/delete_employee_usecase.dart';
import '../../features/employees/domain/usecases/load_employees_home_usecase.dart';
import '../../features/employees/domain/usecases/restart_counter_usecase.dart';
import '../../features/employees/presentation/bloc/employees_bloc.dart';
import '../../features/employee_details/data/datasources/employee_details_remote_data_source.dart';
import '../../features/employee_details/data/repositories/employee_details_repository_impl.dart';
import '../../features/employee_details/domain/usecases/get_employee_data_usecase.dart';
import '../../features/employee_details/presentation/dashboard/dashboard_details_bloc.dart';
import '../../features/employee_details/presentation/profile/profile_details_bloc.dart';
import '../../features/notifications/data/datasources/notification_local_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/save_notifications_usecase.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';

class ServiceLocator {
  static late SharedPreferences _prefs;
  static late NetworkInfo _networkInfo;
  static late NotificationBloc _notificationBloc;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _networkInfo = NetworkInfoImpl(
      connectivity: Connectivity(),
      connectionChecker: InternetConnection(),
    );

    final localDataSource = NotificationLocalDataSourceImpl(_prefs);
    final repository = NotificationRepositoryImpl(localDataSource, _networkInfo);
    final getNotifications = GetNotificationsUseCase(repository);
    final saveNotifications = SaveNotificationsUseCase(repository);

    _notificationBloc = NotificationBloc(
      getNotifications: getNotifications,
      saveNotifications: saveNotifications,
    );
  }

  static NotificationBloc get notificationBloc => _notificationBloc;

  static EmployeesBloc createEmployeesBloc() {
    final remoteDataSource = EmployeesRemoteDataSourceImpl(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      database: FirebaseDatabase.instance,
    );
    final repository = EmployeesRepositoryImpl(remoteDataSource, _networkInfo);

    return EmployeesBloc(
      loadHome: LoadEmployeesHomeUseCase(repository),
      deleteEmployee: DeleteEmployeeUseCase(repository),
      restartCounter: RestartCounterUseCase(repository),
    );
  }

  static ProfileDetailsBloc createProfileDetailsBloc() {
    final remote = EmployeeDetailsRemoteDataSourceImpl(FirebaseDatabase.instance);
    final repo = EmployeeDetailsRepositoryImpl(remote, _networkInfo);
    return ProfileDetailsBloc(GetEmployeeDataUseCase(repo));
  }

  static DashboardDetailsBloc createDashboardDetailsBloc() {
    final remote = EmployeeDetailsRemoteDataSourceImpl(FirebaseDatabase.instance);
    final repo = EmployeeDetailsRepositoryImpl(remote, _networkInfo);
    return DashboardDetailsBloc(GetEmployeeDataUseCase(repo));
  }
}
