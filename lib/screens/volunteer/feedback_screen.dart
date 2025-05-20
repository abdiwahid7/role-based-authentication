import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Event Feedback'),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .where('participants', arrayContains: user?.uid)
              .snapshots(),
          builder: (context, eventSnap) {
            if (!eventSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final events = eventSnap.data!.docs;
            if (events.isEmpty) {
              return const Center(
                child: Text(
                  'No events to rate yet!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('feedback')
                      .where('eventId', isEqualTo: event.id)
                      .where('userId', isEqualTo: user?.uid)
                      .get(),
                  builder: (context, feedbackSnap) {
                    final hasFeedback = feedbackSnap.hasData && feedbackSnap.data!.docs.isNotEmpty;
                    final feedback = hasFeedback ? feedbackSnap.data!.docs.first : null;
                    final rating = feedback != null ? feedback['rating'] : null;
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Color(0xFF6D5BFF), size: 32),
                        title: Text(
                          event['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event['location'] ?? ''),
                            if (hasFeedback)
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  Text(
                                    ' ${rating?.toStringAsFixed(1) ?? ''}  ',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Feedback submitted', style: TextStyle(color: Colors.green)),
                                ],
                              ),
                          ],
                        ),
                        trailing: ElevatedButton.icon(
                          icon: Icon(hasFeedback ? Icons.edit : Icons.feedback, size: 18),
                          label: Text(hasFeedback ? 'Edit' : 'Feedback'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasFeedback ? Colors.orange : const Color(0xFF46C2CB),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (_) => FeedbackBottomSheet(
                                eventId: event.id,
                                eventTitle: event['title'],
                                initialFeedback: feedback?['comment'],
                                initialRating: rating?.toDouble(),
                                feedbackId: feedback?.id,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FeedbackBottomSheet extends StatefulWidget {
  final String eventId;
  final String eventTitle;
  final String? initialFeedback;
  final double? initialRating;
  final String? feedbackId;

  const FeedbackBottomSheet({
    super.key,
    required this.eventId,
    required this.eventTitle,
    this.initialFeedback,
    this.initialRating,
    this.feedbackId,
  });

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  late TextEditingController _feedbackController;
  double _rating = 5;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController(text: widget.initialFeedback ?? '');
    _rating = widget.initialRating ?? 5;
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    setState(() => _submitting = true);
    final user = FirebaseAuth.instance.currentUser;
    final feedbackData = {
      'eventId': widget.eventId,
      'userId': user?.uid,
      'comment': _feedbackController.text.trim(),
      'rating': _rating,
      'timestamp': FieldValue.serverTimestamp(),
    };
    if (widget.feedbackId != null) {
      // Update existing feedback
      await FirebaseFirestore.instance
          .collection('feedback')
          .doc(widget.feedbackId)
          .update(feedbackData);
    } else {
      // Add new feedback
      await FirebaseFirestore.instance.collection('feedback').add(feedbackData);
    }
    setState(() => _submitting = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Feedback for "${widget.eventTitle}"',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF6D5BFF),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Your feedback',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFFF3F6FD),
            ),
            enabled: !_submitting,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text('Rating:', style: TextStyle(fontWeight: FontWeight.w500)),
              Expanded(
                child: Slider(
                  value: _rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _rating.round().toString(),
                  onChanged: _submitting
                      ? null
                      : (value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                ),
              ),
              Text(_rating.toStringAsFixed(1)),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send, size: 20),
              label: Text(widget.feedbackId != null ? 'Update Feedback' : 'Submit Feedback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D5BFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _submitting ? null : _submitFeedback,
            ),
          ),
        ],
      ),
    );
  }
}