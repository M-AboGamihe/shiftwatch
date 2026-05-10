import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<AppNotificationEntity>>> getNotifications();
  Future<Either<Failure, Unit>> saveNotifications(
    List<AppNotificationEntity> notifications,
  );
}
