import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Events & Feedback')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('participants', arrayContains: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final events = snapshot.data!.docs;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final feedbackController = TextEditingController();
              double rating = 5;
              return ListTile(
                title: Text(event['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: feedbackController,
                      decoration: const InputDecoration(labelText: 'Your feedback'),
                    ),
                    Row(
                      children: [
                        const Text('Rating:'),
                        Slider(
                          value: rating,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: rating.round().toString(),
                          onChanged: (value) {
                            rating = value;
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('feedback').add({
                          'eventId': event.id,
                          'userId': user?.uid,
                          'comment': feedbackController.text,
                          'rating': rating,
                        });
                        feedbackController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Feedback submitted!')),
                        );
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}