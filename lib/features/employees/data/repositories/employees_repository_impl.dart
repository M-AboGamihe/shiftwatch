import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/employees_repository.dart';
import '../datasources/employees_remote_data_source.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  EmployeesRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, EmployeesHomeEntity>> loadHome() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final data = await _remoteDataSource.loadHome();
      return Right(data);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEmployee(String employeeName) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.deleteEmployee(employeeName);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> restartCounter() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.restartCounter();
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
