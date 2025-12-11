import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'rate_alerts',
        channelName: 'Rate Alerts',
        channelDescription: 'Notifications for currency rate alerts',
        defaultColor: const Color(0xFF9C27B0),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      ),
    ], debug: false);

    // Request permission
    await requestPermission();
  }

  Future<bool> requestPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }
    return true;
  }

  Future<void> showRateAlert({
    required String id,
    required String title,
    required String body,
    required String baseCurrency,
    required String targetCurrency,
    required double currentRate,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id.hashCode,
        channelKey: 'rate_alerts',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        category: NotificationCategory.Alarm,
        wakeUpScreen: true,
        fullScreenIntent: true,
        criticalAlert: true,
        payload: {
          'alertId': id,
          'baseCurrency': baseCurrency,
          'targetCurrency': targetCurrency,
          'currentRate': currentRate.toString(),
        },
      ),
    );
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<List<NotificationModel>> getActiveNotifications() async {
    return await AwesomeNotifications().listScheduledNotifications();
  }
}
