import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_data_source.dart';
import '../models/app_notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl(this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<AppNotificationEntity>>> getNotifications() async {
    try {
      final notifications = await _localDataSource.getNotifications();
      return Right(notifications);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNotifications(
    List<AppNotificationEntity> notifications,
  ) async {
    final isOnline = await _networkInfo.isConnected;
    if (!isOnline) {
      return const Left(NetworkFailure());
    }

    final models = notifications
        .map((n) => AppNotificationModel.fromEntity(n))
        .toList(growable: false);
    try {
      await _localDataSource.saveNotifications(models);
      return const Right(unit);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
