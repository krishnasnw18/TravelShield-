import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayfinder_bloom/models/incident.dart';

class NotificationService {
  static NotificationService? _instance;
  NotificationService._internal();
  
  static NotificationService get instance {
    _instance ??= NotificationService._internal();
    return _instance!;
  }

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Request notification permission
    await Permission.notification.request();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  Future<void> showSOSNotification(Incident incident) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'sos_alerts',
      'SOS Alerts',
      channelDescription: 'Emergency SOS alert notifications',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFFFF0000),
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.critical,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      '🆘 Emergency Alert Sent',
      'Your SOS alert has been triggered. Emergency services have been notified.',
      notificationDetails,
    );
  }

  Future<void> showGeofenceAlert(String zoneName, String warningMessage) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'geofence_alerts',
      'Geofence Alerts',
      channelDescription: 'Location-based safety alerts',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFFFF9800),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      2,
      '⚠️ Restricted Zone Alert',
      'You are near $zoneName. $warningMessage',
      notificationDetails,
    );
  }

  Future<void> showSafetyTip(String title, String message) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'safety_tips',
      'Safety Tips',
      channelDescription: 'Travel safety tips and reminders',
      importance: Importance.low,
      priority: Priority.low,
      color: Color(0xFF2196F3),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      3,
      title,
      message,
      notificationDetails,
    );
  }

  Future<void> showIncidentUpdate(Incident incident) async {
    await initialize();

    String statusMessage;
    switch (incident.status) {
      case IncidentStatus.acknowledged:
        statusMessage = 'Your incident has been acknowledged by authorities.';
        break;
      case IncidentStatus.resolved:
        statusMessage = 'Your incident has been resolved. You are now safe.';
        break;
      default:
        statusMessage = 'Incident status updated.';
    }

    const androidDetails = AndroidNotificationDetails(
      'incident_updates',
      'Incident Updates',
      channelDescription: 'Updates on reported incidents',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      color: Color(0xFF4CAF50),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      4,
      'Incident Update',
      statusMessage,
      notificationDetails,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}