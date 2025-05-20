import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteeringProfileScreen extends StatelessWidget {
  const VolunteeringProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Profile'),
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
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Card(
                elevation: 16,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, size: 56, color: Color(0xFF6D5BFF)),
                      const SizedBox(height: 12),
                      Text('Name: ${data['displayName'] ?? ''}', style: const TextStyle(fontSize: 18)),
                      Text('Email: ${data['email']}', style: const TextStyle(fontSize: 18)),
                      Text('Hours Served: ${data['hoursServed'] ?? 0}', style: const TextStyle(fontSize: 18)),
                      Text('Badges: ${(data['badges'] as List).join(', ')}', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}