import 'package:equatable/equatable.dart';

class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class AddNotificationEvent extends NotificationEvent {
  final String message;
  final DateTime? timestamp;

  AddNotificationEvent({required this.message, this.timestamp});

  @override
  List<Object?> get props => [message, timestamp];
}

class RemoveNotificationEvent extends NotificationEvent {
  final int index;

  RemoveNotificationEvent(this.index);

  @override
  List<Object?> get props => [index];
}
