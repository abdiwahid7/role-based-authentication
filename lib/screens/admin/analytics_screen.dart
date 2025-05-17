import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Future<int> _getCount(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: FutureBuilder(
        future: Future.wait([
          _getCount('users'),
          _getCount('events'),
        ]),
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final userCount = snapshot.data![0];
          final eventCount = snapshot.data![1];
          return ListView(
            children: [
              ListTile(
                title: const Text('Total Users'),
                trailing: Text('$userCount'),
              ),
              ListTile(
                title: const Text('Total Events'),
                trailing: Text('$eventCount'),
              ),
              // Add more analytics as needed
            ],
          );
        },
      ),
    );
  }
}