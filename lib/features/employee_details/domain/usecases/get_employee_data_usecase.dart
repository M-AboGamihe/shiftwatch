import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/employee_details_repository.dart';

class GetEmployeeDataUseCase {
  final EmployeeDetailsRepository _repository;

  GetEmployeeDataUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String username,
    required String employeeName,
  }) {
    return _repository.getEmployeeData(
      username: username,
      employeeName: employeeName,
    );
  }
}
