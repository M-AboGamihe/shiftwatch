import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/employees_repository.dart';

class RestartCounterUseCase {
  final EmployeesRepository _repository;

  RestartCounterUseCase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.restartCounter();
  }
}
