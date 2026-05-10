import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_employee_data_usecase.dart';
import 'dashboard_details_event.dart';
import 'dashboard_details_state.dart';

class DashboardDetailsBloc extends Bloc<DashboardDetailsEvent, DashboardDetailsState> {
  final GetEmployeeDataUseCase _getEmployeeDataUseCase;

  DashboardDetailsBloc(this._getEmployeeDataUseCase)
      : super(const DashboardDetailsState(isLoading: true)) {
    on<LoadDashboardDetailsEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadDashboardDetailsEvent event,
    Emitter<DashboardDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getEmployeeDataUseCase(
      username: event.username,
      employeeName: event.employeeName,
    );
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (data) => emit(state.copyWith(isLoading: false, employeeData: data, clearError: true)),
    );
  }
}
