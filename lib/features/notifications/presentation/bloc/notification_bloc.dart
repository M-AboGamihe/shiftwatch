import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/save_notifications_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotifications;
  final SaveNotificationsUseCase _saveNotifications;

  NotificationBloc({
    required GetNotificationsUseCase getNotifications,
    required SaveNotificationsUseCase saveNotifications,
  })  : _getNotifications = getNotifications,
        _saveNotifications = saveNotifications,
        super(const NotificationState(isLoading: true)) {
    on<LoadNotificationsEvent>(_onLoad);
    on<AddNotificationEvent>(_onAdd);
    on<RemoveNotificationEvent>(_onRemove);
  }

  Future<void> _onLoad(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getNotifications();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (notifications) => emit(
        state.copyWith(
          notifications: notifications,
          isLoading: false,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onAdd(
    AddNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final updated = <AppNotificationEntity>[
      AppNotificationEntity(
        message: event.message,
        timestamp: event.timestamp ?? DateTime.now(),
      ),
      ...state.notifications,
    ];
    emit(state.copyWith(notifications: updated, clearError: true));
    final saveResult = await _saveNotifications(updated);
    saveResult.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {},
    );
  }

  Future<void> _onRemove(
    RemoveNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (event.index < 0 || event.index >= state.notifications.length) {
      return;
    }
    final updated = List<AppNotificationEntity>.from(state.notifications)
      ..removeAt(event.index);
    emit(state.copyWith(notifications: updated, clearError: true));
    final saveResult = await _saveNotifications(updated);
    saveResult.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {},
    );
  }
}
