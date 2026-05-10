import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/employee_details_repository.dart';
import '../datasources/employee_details_remote_data_source.dart';

class EmployeeDetailsRepositoryImpl implements EmployeeDetailsRepository {
  final EmployeeDetailsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  EmployeeDetailsRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getEmployeeData({
    required String username,
    required String employeeName,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final data = await _remoteDataSource.getEmployeeData(
        username: username,
        employeeName: employeeName,
      );
      return Right(data);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
