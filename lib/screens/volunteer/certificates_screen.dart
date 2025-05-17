import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('My Certificates')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('certificates')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final certs = snapshot.data!.docs;
          if (certs.isEmpty) return const Center(child: Text('No certificates yet.'));
          return ListView.builder(
            itemCount: certs.length,
            itemBuilder: (context, index) {
              final cert = certs[index];
              return ListTile(
                title: Text(cert['eventTitle'] ?? 'Certificate'),
                subtitle: Text('Date: ${cert['date'] ?? ''}'),
                trailing: cert['url'] != null
                    ? IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          // TODO: Open/download certificate from cert['url']
                        },
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}