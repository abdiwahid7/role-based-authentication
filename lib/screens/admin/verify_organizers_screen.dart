import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyOrganizersScreen extends StatelessWidget {
  const VerifyOrganizersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Organizers')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'ngo')
            .where('verified', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final organizers = snapshot.data!.docs;
          if (organizers.isEmpty) {
            return const Center(child: Text('No organizers to verify.'));
          }
          return ListView.builder(
            itemCount: organizers.length,
            itemBuilder: (context, index) {
              final org = organizers[index];
              return ListTile(
                title: Text(org['displayName'] ?? org['email']),
                subtitle: Text('Email: ${org['email']}'),
                trailing: ElevatedButton(
                  child: const Text('Verify'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(org.id)
                        .update({'verified': true});
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