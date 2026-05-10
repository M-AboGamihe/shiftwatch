import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/delete_employee_usecase.dart';
import '../../domain/usecases/load_employees_home_usecase.dart';
import '../../domain/usecases/restart_counter_usecase.dart';
import 'employees_event.dart';
import 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final LoadEmployeesHomeUseCase _loadHome;
  final DeleteEmployeeUseCase _deleteEmployee;
  final RestartCounterUseCase _restartCounter;

  EmployeesBloc({
    required LoadEmployeesHomeUseCase loadHome,
    required DeleteEmployeeUseCase deleteEmployee,
    required RestartCounterUseCase restartCounter,
  })  : _loadHome = loadHome,
        _deleteEmployee = deleteEmployee,
        _restartCounter = restartCounter,
        super(const EmployeesState(isLoading: true)) {
    on<LoadEmployeesEvent>(_onLoad);
    on<DeleteEmployeeEvent>(_onDelete);
    on<RestartCounterEvent>(_onRestart);
  }

  Future<void> _onLoad(LoadEmployeesEvent event, Emitter<EmployeesState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearInfo: true));
    final result = await _loadHome();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (data) => emit(
        state.copyWith(
          isLoading: false,
          username: data.username,
          employees: data.employees,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onDelete(DeleteEmployeeEvent event, Emitter<EmployeesState> emit) async {
    final result = await _deleteEmployee(event.employeeName);
    await result.fold(
      (failure) async => emit(state.copyWith(errorMessage: failure.message)),
      (_) async {
        emit(state.copyWith(infoMessage: '${event.employeeName} deleted successfully'));
        add(LoadEmployeesEvent());
      },
    );
  }

  Future<void> _onRestart(RestartCounterEvent event, Emitter<EmployeesState> emit) async {
    final result = await _restartCounter();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(infoMessage: 'Restart +1 completed')),
    );
  }
}
