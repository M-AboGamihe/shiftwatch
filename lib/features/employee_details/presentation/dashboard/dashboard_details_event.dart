import 'package:equatable/equatable.dart';

class DashboardDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDashboardDetailsEvent extends DashboardDetailsEvent {
  final String username;
  final String employeeName;

  LoadDashboardDetailsEvent({
    required this.username,
    required this.employeeName,
  });

  @override
  List<Object?> get props => [username, employeeName];
}
