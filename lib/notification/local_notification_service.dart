import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications_repository/notification/notification_service.dart';
import 'package:flutter_notifications_repository/sample_navigation/app_navigation.dart';

class LocalNotificationService {
  final AppNavigation navigation;
  LocalNotificationService(this.navigation);
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handling notification tap
        final payload = response.payload;
        if (payload != null) {
          final data = json.decode(payload);
          final screen = NotificationService.getScreenType(data);
          navigation.push(screen.$1, arguments: screen.$2);
        }
      },
    );
  }

  static Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationDetails? details,
  }) async {
    const defaultDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        channelDescription: 'Default notification channel',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details ?? defaultDetails,
      payload: payload,
    );
  }

  Future<void> cancelLocalNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> cancelAllLocalNotifications() async {
    await _localNotifications.cancelAll();
  }
}
