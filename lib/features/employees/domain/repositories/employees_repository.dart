import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/employee_summary_entity.dart';

class EmployeesHomeEntity {
  final String username;
  final List<EmployeeSummaryEntity> employees;

  const EmployeesHomeEntity({
    required this.username,
    required this.employees,
  });
}

abstract class EmployeesRepository {
  Future<Either<Failure, EmployeesHomeEntity>> loadHome();
  Future<Either<Failure, Unit>> deleteEmployee(String employeeName);
  Future<Either<Failure, Unit>> restartCounter();
}
