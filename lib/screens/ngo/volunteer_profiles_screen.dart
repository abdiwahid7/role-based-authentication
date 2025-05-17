import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerProfilesScreen extends StatelessWidget {
  const VolunteerProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Volunteer Profiles')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('organizerId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final events = snapshot.data!.docs;
          final participantIds = <String>{};
          for (var event in events) {
            final participants = List<String>.from(event['participants'] ?? []);
            participantIds.addAll(participants);
          }
          if (participantIds.isEmpty) {
            return const Center(child: Text('No volunteers yet.'));
          }
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: participantIds.toList())
                .get(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());
              final users = userSnapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final volunteer = users[index];
                  return ListTile(
                    title: Text(volunteer['displayName'] ?? volunteer['email']),
                    subtitle: Text('Hours Served: ${volunteer['hoursServed'] ?? 0}'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}