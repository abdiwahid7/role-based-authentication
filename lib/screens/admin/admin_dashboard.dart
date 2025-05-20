import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'manage_users_screen.dart';
import 'verify_organizers_screen.dart';
import 'analytics_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D5BFF), Color(0xFF46C2CB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.admin_panel_settings, size: 56, color: Color(0xFF6D5BFF)),
                        const SizedBox(height: 12),
                        const Text(
                          'Welcome, Admin!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D5BFF),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _DashboardButton(
                          icon: Icons.people,
                          color: Colors.blue,
                          label: 'Manage Users',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _DashboardButton(
                          icon: Icons.verified_user,
                          color: Colors.green,
                          label: 'Verify Organizers',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VerifyOrganizersScreen()),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _DashboardButton(
                          icon: Icons.analytics,
                          color: Colors.deepPurple,
                          label: 'View Analytics',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _DashboardButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 28),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          shadowColor: color.withOpacity(0.3),
        ),
        onPressed: onTap,
      ),
    );
  }
}