import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Either<Failure, List<AppNotificationEntity>>> call() {
    return _repository.getNotifications();
  }
}
