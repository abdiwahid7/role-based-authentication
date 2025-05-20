import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageEventsScreen extends StatelessWidget {
  const ManageEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manage Events'),
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
                          leading: const Icon(Icons.event, color: Colors.green, size: 32),
                          title: Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(event['date'] != null && event['date'] is Timestamp
                              ? event['date'].toDate().toString()
                              : ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility, color: Colors.blue),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EventViewDialog(event: event),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EventEditDialog(event: event),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(event.id)
                                      .delete();
                                },
                              ),
                            ],
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

class EventViewDialog extends StatelessWidget {
  final QueryDocumentSnapshot event;
  const EventViewDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(event['title']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description: ${event['description']}'),
          Text('Location: ${event['location']}'),
          Text('Date: ${event['date'] != null && event['date'] is Timestamp ? event['date'].toDate().toString() : ''}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class EventEditDialog extends StatefulWidget {
  final QueryDocumentSnapshot event;
  const EventEditDialog({super.key, required this.event});

  @override
  State<EventEditDialog> createState() => _EventEditDialogState();
}

class _EventEditDialogState extends State<EventEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event['title']);
    _descController = TextEditingController(text: widget.event['description']);
    _locationController = TextEditingController(text: widget.event['location']);
    _date = widget.event['date'] != null && widget.event['date'] is Timestamp
        ? widget.event['date'].toDate()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Edit Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(_date == null ? 'Pick Date' : _date.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await widget.event.reference.update({
              'title': _titleController.text,
              'description': _descController.text,
              'location': _locationController.text,
              'date': _date,
            });
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}