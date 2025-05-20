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
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<int>(
              future: _getCount('users'),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.people, color: Colors.blue, size: 36),
                    title: const Text('Total Users'),
                    trailing: Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<int>(
              future: _getCount('events'),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.green, size: 36),
                    title: const Text('Total Events'),
                    trailing: Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}