import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerProfilesScreen extends StatelessWidget {
  const VolunteerProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Volunteer Profiles'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
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
        child: StreamBuilder<QuerySnapshot>(
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
              return const Center(child: Text('No volunteers yet.', style: TextStyle(color: Colors.white, fontSize: 18)));
            }
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(FieldPath.documentId, whereIn: participantIds.toList())
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                final users = userSnapshot.data!.docs;
                return Center(
                  child: Card(
                    elevation: 16,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final volunteer = users[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            child: ListTile(
                              leading: const Icon(Icons.person, color: Colors.deepPurple, size: 32),
                              title: Text(volunteer['displayName'] ?? volunteer['email'],
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Hours Served: ${volunteer['hoursServed'] ?? 0}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}