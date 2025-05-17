import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> generateCertificate(String userId, String eventTitle) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Text('Certificate of Volunteering\n$eventTitle'),
      ),
    ),
  );
  final bytes = await pdf.save();
  final ref = FirebaseStorage.instance.ref().child('certificates/$userId-$eventTitle.pdf');
  await ref.putData(bytes);
  final url = await ref.getDownloadURL();
  await FirebaseFirestore.instance.collection('certificates').add({
    'userId': userId,
    'eventTitle': eventTitle,
    'url': url,
    'date': DateTime.now().toString(),
  });
}