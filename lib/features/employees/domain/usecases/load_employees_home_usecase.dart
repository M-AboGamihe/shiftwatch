import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/employees_repository.dart';

class LoadEmployeesHomeUseCase {
  final EmployeesRepository _repository;

  LoadEmployeesHomeUseCase(this._repository);

  Future<Either<Failure, EmployeesHomeEntity>> call() {
    return _repository.loadHome();
  }
}
