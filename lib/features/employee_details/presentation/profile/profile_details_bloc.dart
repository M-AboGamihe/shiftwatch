import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_employee_data_usecase.dart';
import 'profile_details_event.dart';
import 'profile_details_state.dart';

class ProfileDetailsBloc extends Bloc<ProfileDetailsEvent, ProfileDetailsState> {
  final GetEmployeeDataUseCase _getEmployeeDataUseCase;

  ProfileDetailsBloc(this._getEmployeeDataUseCase)
      : super(const ProfileDetailsState(isLoading: true)) {
    on<LoadProfileDetailsEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadProfileDetailsEvent event,
    Emitter<ProfileDetailsState> emit,
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
