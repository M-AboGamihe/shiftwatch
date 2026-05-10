import 'package:equatable/equatable.dart';

class EmployeesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEmployeesEvent extends EmployeesEvent {}

class DeleteEmployeeEvent extends EmployeesEvent {
  final String employeeName;

  DeleteEmployeeEvent(this.employeeName);

  @override
  List<Object?> get props => [employeeName];
}

class RestartCounterEvent extends EmployeesEvent {}
