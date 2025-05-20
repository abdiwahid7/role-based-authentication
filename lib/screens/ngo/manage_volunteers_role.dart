import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignRolesScreen extends StatefulWidget {
  final String eventId;
  const AssignRolesScreen({super.key, required this.eventId});

  @override
  State<AssignRolesScreen> createState() => _AssignRolesScreenState();
}

class _AssignRolesScreenState extends State<AssignRolesScreen> {
  final _roles = ['Leader', 'Coordinator', 'Member'];
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Roles')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .collection('volunteers')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final volunteers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final volunteer = volunteers[index];
              return ListTile(
                title: Text(volunteer['name'] ?? 'No Name'),
                subtitle: Text('Current role: ${volunteer['role'] ?? 'None'}'),
                trailing: DropdownButton<String>(
                  value: volunteer['role'],
                  hint: const Text('Assign Role'),
                  items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                  onChanged: (role) async {
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(widget.eventId)
                        .collection('volunteers')
                        .doc(volunteer.id)
                        .update({'role': role});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}