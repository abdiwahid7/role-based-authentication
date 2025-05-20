import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventReportsScreen extends StatelessWidget {
  const EventReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Event Reports/Updates'),
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Container(
              width: 500,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .where('organizerId', isEqualTo: user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final events = snapshot.data!.docs;
                  if (events.isEmpty) {
                    return const Center(
                      child: Text(
                        'No events found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: ListTile(
                          leading: const Icon(Icons.event_note, color: Colors.deepPurple, size: 32),
                          title: Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(event['report'] ?? 'No report yet'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditReportDialog(
                                  eventId: event.id,
                                  initialReport: event['report'] ?? '',
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}