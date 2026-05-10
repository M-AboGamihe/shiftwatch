import 'package:equatable/equatable.dart';

class AppNotificationEntity extends Equatable {
  final String message;
  final DateTime timestamp;

  const AppNotificationEntity({
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [message, timestamp];
}
