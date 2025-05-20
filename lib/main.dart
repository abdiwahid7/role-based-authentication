import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/ngo/ngo_dashboard.dart';
import 'screens/volunteer/volunteer_dashboard.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();
  await NotificationService.requestPermission();
  runApp(const LocalLoopApp());
}

class LocalLoopApp extends StatelessWidget {
  const LocalLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalLoop',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
       initialRoute: '/',
  routes: {
    '/': (context) => const LoginScreen(), // Make sure this is present!
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/forgot-password': (context) => ForgotPasswordPage(),
    '/admin': (context) => const AdminDashboard(),
    '/ngo': (context) => const NGODashboard(),
    '/volunteer': (context) => const VolunteerDashboard(),
  },
    );
  }
}