import 'package:equatable/equatable.dart';

import '../../domain/entities/employee_summary_entity.dart';

class EmployeesState extends Equatable {
  final bool isLoading;
  final String? username;
  final List<EmployeeSummaryEntity> employees;
  final String? errorMessage;
  final String? infoMessage;

  const EmployeesState({
    this.isLoading = false,
    this.username,
    this.employees = const [],
    this.errorMessage,
    this.infoMessage,
  });

  EmployeesState copyWith({
    bool? isLoading,
    String? username,
    List<EmployeeSummaryEntity>? employees,
    String? errorMessage,
    String? infoMessage,
    bool clearError = false,
    bool clearInfo = false,
  }) {
    return EmployeesState(
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      employees: employees ?? this.employees,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, username, employees, errorMessage, infoMessage];
}
