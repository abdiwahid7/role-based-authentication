import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service to handle push and local notifications.
class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  /// Initializes notification services and listeners.
  static Future<void> initialize() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(settings);

    // Listen for foreground messages and show local notifications.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _localNotifications.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'main_channel',
              'Main Channel',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  /// Requests notification permissions from the user.
  static Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }
}