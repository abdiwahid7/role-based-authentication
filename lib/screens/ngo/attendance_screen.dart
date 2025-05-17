import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance & Hours')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('organizerId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final events = snapshot.data!.docs;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final participants = List<String>.from(event['participants'] ?? []);
              return ExpansionTile(
                title: Text(event['title']),
                children: participants.map((pid) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(pid).get(),
                    builder: (context, userSnap) {
                      if (!userSnap.hasData) return const ListTile(title: Text('Loading...'));
                      final volunteer = userSnap.data!;
                      return ListTile(
                        title: Text(volunteer['displayName'] ?? volunteer['email']),
                        subtitle: Text('Hours Served: ${volunteer['hoursServed'] ?? 0}'),
                        // TODO: Add check-in/check-out and update hours logic here
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}