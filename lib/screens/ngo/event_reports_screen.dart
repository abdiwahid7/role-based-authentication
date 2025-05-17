import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventReportsScreen extends StatelessWidget {
  const EventReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Event Reports/Updates')),
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
              return ListTile(
                title: Text(event['title']),
                subtitle: Text(event['report'] ?? 'No report yet'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => EditReportDialog(eventId: event.id, initialReport: event['report'] ?? ''),
                    );
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

class EditReportDialog extends StatefulWidget {
  final String eventId;
  final String initialReport;
  const EditReportDialog({super.key, required this.eventId, required this.initialReport});

  @override
  State<EditReportDialog> createState() => _EditReportDialogState();
}

class _EditReportDialogState extends State<EditReportDialog> {
  late TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialReport);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Event Report'),
      content: TextField(
        controller: _controller,
        maxLines: 5,
        decoration: const InputDecoration(labelText: 'Event Report/Update'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving
              ? null
              : () async {
                  setState(() => _saving = true);
                  await FirebaseFirestore.instance
                      .collection('events')
                      .doc(widget.eventId)
                      .update({'report': _controller.text});
                  setState(() => _saving = false);
                  Navigator.pop(context);
                },
          child: _saving ? const CircularProgressIndicator() : const Text('Save'),
        ),
      ],
    );
  }
}