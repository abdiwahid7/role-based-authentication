import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'manage_users_screen.dart';
import 'verify_organizers_screen.dart';
import 'analytics_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
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
          body: constraints.maxWidth > 600
              ? Row(
                  children: [
                    Expanded(child: _buildMenu(context)),
                    const VerticalDivider(width: 1),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Select an option from the menu',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                )
              : _buildMenu(context),
        );
      },
    );
  }

  Widget _buildMenu(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Manage Users'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified_user),
          title: const Text('Verify Organizers'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerifyOrganizersScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('View Analytics'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
            );
          },
        ),
      ],
    );
  }
}