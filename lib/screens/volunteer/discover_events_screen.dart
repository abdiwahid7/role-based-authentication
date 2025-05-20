import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class DiscoverEventsScreen extends StatefulWidget {
  const DiscoverEventsScreen({super.key});

  @override
  State<DiscoverEventsScreen> createState() => _DiscoverEventsScreenState();
}

class _DiscoverEventsScreenState extends State<DiscoverEventsScreen> {
  Position? _position;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {});
    } catch (e) {
      // Handle location error
    }
  }

  double? _distanceFromUser(Map<String, dynamic> event) {
    if (_position == null || event['lat'] == null || event['lng'] == null) return null;
    return Geolocator.distanceBetween(
      _position!.latitude,
      _position!.longitude,
      event['lat'],
      event['lng'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Nearby Events'),
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
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final events = snapshot.data!.docs;
            if (events.isEmpty) return const Center(child: Text('No events found.', style: TextStyle(color: Colors.white, fontSize: 18)));
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final data = event.data() as Map<String, dynamic>;
                final participants = List<String>.from(data['participants'] ?? []);
                final checkIns = List<Map<String, dynamic>>.from(data['checkIns'] ?? []);
                final checkOuts = List<Map<String, dynamic>>.from(data['checkOuts'] ?? []);
                final alreadyRegistered = user != null && participants.contains(user.uid);
                final checkedIn = user != null && checkIns.any((ci) => ci['userId'] == user.uid);
                final checkedOut = user != null && checkOuts.any((co) => co['userId'] == user.uid);
                final distance = _distanceFromUser(data);

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(data['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['location'] ?? ''),
                        if (distance != null)
                          Text('Distance: ${(distance / 1000).toStringAsFixed(1)} km'),
                        if (alreadyRegistered)
                          const Text('You are registered', style: TextStyle(color: Colors.green)),
                        if (checkedIn && !checkedOut)
                          const Text('You are checked in', style: TextStyle(color: Colors.blue)),
                        if (checkedOut)
                          const Text('You are checked out', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!alreadyRegistered)
                          ElevatedButton(
                            child: const Text('Register'),
                            onPressed: user == null
                                ? null
                                : () async {
                                    await FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(event.id)
                                        .update({
                                      'participants': FieldValue.arrayUnion([user.uid])
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Registered for event!')),
                                    );
                                    setState(() {});
                                  },
                          ),
                        if (alreadyRegistered && !checkedIn)
                          ElevatedButton(
                            child: const Text('Check In'),
                            onPressed: user == null
                                ? null
                                : () async {
                                    await FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(event.id)
                                        .update({
                                      'checkIns': FieldValue.arrayUnion([
                                        {'userId': user.uid, 'time': Timestamp.now()}
                                      ])
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Checked in!')),
                                    );
                                    setState(() {});
                                  },
                          ),
                        if (alreadyRegistered && checkedIn && !checkedOut)
                          ElevatedButton(
                            child: const Text('Check Out'),
                            onPressed: user == null
                                ? null
                                : () async {
                                    await FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(event.id)
                                        .update({
                                      'checkOuts': FieldValue.arrayUnion([
                                        {'userId': user.uid, 'time': Timestamp.now()}
                                      ])
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Checked out!')),
                                    );
                                    setState(() {});
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
    );
  }
}