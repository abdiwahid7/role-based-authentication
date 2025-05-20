import 'package:flutter/material.dart';
import '../../utilis/certificate_generator.dart';
import 'package:open_file/open_file.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificates')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final file = await generateCertificate(
              volunteerName: 'John Doe', // Replace with actual volunteer name
              eventName: 'Tree Plantation', // Replace with actual event name
              hours: 5, // Replace with actual hours
            );
            OpenFile.open(file.path);
          },
          child: const Text('Generate Certificate'),
        ),
      ),
    );
  }
}