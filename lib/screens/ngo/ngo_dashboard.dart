import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_event_screen.dart';
import 'manage_events_screen.dart';
import 'volunteer_profiles_screen.dart';
import 'attendance_screen.dart';
import 'event_reports_screen.dart';

class NGODashboard extends StatelessWidget {
  const NGODashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
            child: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.volunteer_activism, size: 56, color: Color(0xFF6D5BFF)),
                    const SizedBox(height: 12),
                    const Text(
                      'Welcome, NGO!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D5BFF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _DashboardButton(
                      icon: Icons.add_circle,
                      color: Colors.blue,
                      label: 'Create Volunteer Opportunity',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateEventScreen()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DashboardButton(
                      icon: Icons.event,
                      color: Colors.green,
                      label: 'Manage Events',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageEventsScreen()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DashboardButton(
                      icon: Icons.people,
                      color: Colors.deepPurple,
                      label: 'View Volunteer Profiles',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VolunteerProfilesScreen()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DashboardButton(
                      icon: Icons.access_time,
                      color: Colors.orange,
                      label: 'Track Attendance & Hours',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DashboardButton(
                      icon: Icons.report,
                      color: Colors.redAccent,
                      label: 'Post Event Reports/Updates',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EventReportsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
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
      width: 260,
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