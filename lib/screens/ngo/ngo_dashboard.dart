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
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
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
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Create Volunteer Opportunity'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Manage Events'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageEventsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('View Volunteer Profiles'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VolunteerProfilesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Track Attendance & Hours'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Post Event Reports/Updates'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EventReportsScreen()));
            },
          ),
        ],
      ),
    );
  }
}