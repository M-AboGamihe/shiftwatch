import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<List<AppNotificationModel>> getNotifications();
  Future<void> saveNotifications(List<AppNotificationModel> notifications);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const _storageKey = 'notifications';
  final SharedPreferences _prefs;

  NotificationLocalDataSourceImpl(this._prefs);

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    final stored = _prefs.getStringList(_storageKey) ?? <String>[];
    return stored
        .map((item) => AppNotificationModel.fromJson(
            json.decode(item) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveNotifications(List<AppNotificationModel> notifications) {
    final encoded = notifications.map((n) => json.encode(n.toJson())).toList();
    return _prefs.setStringList(_storageKey, encoded);
  }
}
