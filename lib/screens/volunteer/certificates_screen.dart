import 'package:flutter/material.dart';
import '../../utilis/certificate_generator.dart';
import 'package:open_file/open_file.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Certificates'),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  'Generate Certificate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D5BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                onPressed: () async {
                  final file = await generateCertificate(
                    volunteerName: 'John Doe', // Replace with actual volunteer name
                    eventName: 'Tree Plantation', // Replace with actual event name
                    hours: 5, // Replace with actual hours
                  );
                  OpenFile.open(file.path);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}