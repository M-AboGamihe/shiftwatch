import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_notification_entity.dart';
import '../repositories/notification_repository.dart';

class SaveNotificationsUseCase {
  final NotificationRepository _repository;

  SaveNotificationsUseCase(this._repository);

  Future<Either<Failure, Unit>> call(List<AppNotificationEntity> notifications) {
    return _repository.saveNotifications(notifications);
  }
}
