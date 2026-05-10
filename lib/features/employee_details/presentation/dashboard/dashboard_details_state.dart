import 'package:equatable/equatable.dart';

class DashboardDetailsState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? employeeData;
  final String? errorMessage;

  const DashboardDetailsState({
    this.isLoading = false,
    this.employeeData,
    this.errorMessage,
  });

  DashboardDetailsState copyWith({
    bool? isLoading,
    Map<String, dynamic>? employeeData,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardDetailsState(
      isLoading: isLoading ?? this.isLoading,
      employeeData: employeeData ?? this.employeeData,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, employeeData, errorMessage];
}
