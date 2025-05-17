import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'discover_events_screen.dart';
import 'volunteering_profile_screen.dart';
import 'certificates_screen.dart';
import 'feedback_screen.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Dashboard'),
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
            leading: const Icon(Icons.location_on),
            title: const Text('Discover Nearby Events'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DiscoverEventsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Volunteering Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VolunteeringProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text('My Certificates'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CertificatesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Rate Events & Give Feedback'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
            },
          ),
        ],
      ),
    );
  }
}