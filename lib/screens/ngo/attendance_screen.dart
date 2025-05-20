import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Track Attendance'),
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
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final events = snapshot.data!.docs;
            if (events.isEmpty) {
              return const Center(
                child: Text(
                  'No events found.',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final data = event.data() as Map<String, dynamic>;

                final participants = List<String>.from(data['participants'] ?? []);

                // Safe extraction for checkIns and checkOuts
                final checkInsRaw = data.containsKey('checkIns') && data['checkIns'] is List
                    ? data['checkIns']
                    : [];
                final checkOutsRaw = data.containsKey('checkOuts') && data['checkOuts'] is List
                    ? data['checkOuts']
                    : [];
                final checkIns = List<Map<String, dynamic>>.from(checkInsRaw);
                final checkOuts = List<Map<String, dynamic>>.from(checkOutsRaw);

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  child: ExpansionTile(
                    leading: const Icon(Icons.event, color: Color(0xFF6D5BFF), size: 32),
                    title: Text(
                      data['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(data['location'] ?? ''),
                    children: participants.isEmpty
                        ? [
                            const ListTile(
                              title: Text('No participants yet.'),
                            )
                          ]
                        : participants.map((pid) {
                            final checkIn = checkIns.firstWhere(
                                (ci) => ci['userId'] == pid,
                                orElse: () => {});
                            final checkOut = checkOuts.firstWhere(
                                (co) => co['userId'] == pid,
                                orElse: () => {});
                            DateTime? inTime = checkIn['time'] != null && checkIn['time'] is Timestamp
                                ? (checkIn['time'] as Timestamp).toDate()
                                : null;
                            DateTime? outTime = checkOut['time'] != null && checkOut['time'] is Timestamp
                                ? (checkOut['time'] as Timestamp).toDate()
                                : null;
                            double? hours;
                            if (inTime != null && outTime != null) {
                              hours = outTime.difference(inTime).inMinutes / 60.0;
                            }
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('users').doc(pid).get(),
                              builder: (context, userSnap) {
                                if (!userSnap.hasData) {
                                  return const ListTile(title: Text('Loading...'));
                                }
                                final volunteer = userSnap.data!;
                                return ListTile(
                                  leading: const Icon(Icons.person, color: Colors.deepPurple),
                                  title: Text(volunteer['displayName'] ?? volunteer['email']),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (inTime != null)
                                        Text('Check-in: ${inTime.toLocal()}'),
                                      if (outTime != null)
                                        Text('Check-out: ${outTime.toLocal()}'),
                                      if (hours != null)
                                        Text('Total hours: ${hours.toStringAsFixed(2)}'),
                                      if (inTime == null)
                                        const Text('Not checked in', style: TextStyle(color: Colors.red)),
                                      if (inTime != null && outTime == null)
                                        const Text('Checked in, not checked out', style: TextStyle(color: Colors.orange)),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
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