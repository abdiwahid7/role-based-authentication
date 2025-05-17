import 'package:flutter/material.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch events from Firestore and display them
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: ListView(
        children: [
          // Example event card
          ListTile(
            title: const Text('Community Clean-up'),
            subtitle: const Text('May 25, 2025 - Central Park'),
            onTap: () {
              // TODO: Navigate to event detail screen
            },
          ),
        ],
      ),
    );
  }
}