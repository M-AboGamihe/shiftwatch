import '../../domain/entities/app_notification_entity.dart';

class AppNotificationModel extends AppNotificationEntity {
  const AppNotificationModel({
    required super.message,
    required super.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      message: (json['message'] ?? '').toString(),
      timestamp: DateTime.tryParse((json['timestamp'] ?? '').toString()) ??
          DateTime.now(),
    );
  }

  factory AppNotificationModel.fromEntity(AppNotificationEntity entity) {
    return AppNotificationModel(
      message: entity.message,
      timestamp: entity.timestamp,
    );
  }
}
