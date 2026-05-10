import 'package:equatable/equatable.dart';

class ProfileDetailsState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? employeeData;
  final String? errorMessage;

  const ProfileDetailsState({
    this.isLoading = false,
    this.employeeData,
    this.errorMessage,
  });

  ProfileDetailsState copyWith({
    bool? isLoading,
    Map<String, dynamic>? employeeData,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileDetailsState(
      isLoading: isLoading ?? this.isLoading,
      employeeData: employeeData ?? this.employeeData,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, employeeData, errorMessage];
}
