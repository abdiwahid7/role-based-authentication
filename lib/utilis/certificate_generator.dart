import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> generateCertificate({
  required String volunteerName,
  required String eventName,
  required int hours,
}) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Certificate of Volunteering', style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('This certifies that', style: pw.TextStyle(fontSize: 18)),
            pw.Text(volunteerName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Text('has successfully volunteered for', style: pw.TextStyle(fontSize: 18)),
            pw.Text(eventName, style: pw.TextStyle(fontSize: 20)),
            pw.Text('and served $hours hours.', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 40),
            pw.Text('Thank you for your service!', style: pw.TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
  final output = await getTemporaryDirectory();
  final file = File('${output.path}/certificate.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}