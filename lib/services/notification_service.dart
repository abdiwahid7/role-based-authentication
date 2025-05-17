import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
    // Handle foreground/background messages as needed
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}