import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Future<int> _getCount(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Analytics'),
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
        child: Center(
          child: Card(
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<int>(
                    future: _getCount('users'),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.people,
                            color: Colors.blue,
                            size: 36,
                          ),
                          title: const Text('Total Users', style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder<int>(
                    future: _getCount('events'),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.event,
                            color: Colors.green,
                            size: 36,
                          ),
                          title: const Text('Total Events', style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}