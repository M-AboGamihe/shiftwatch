import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/employees_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeesRepository _repository;

  DeleteEmployeeUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String employeeName) {
    return _repository.deleteEmployee(employeeName);
  }
}
