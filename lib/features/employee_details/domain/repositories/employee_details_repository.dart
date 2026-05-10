import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class EmployeeDetailsRepository {
  Future<Either<Failure, Map<String, dynamic>>> getEmployeeData({
    required String username,
    required String employeeName,
  });
}
