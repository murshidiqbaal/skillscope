import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:mobile/features/profile/data/models/profile_model.dart';

class ProfilePdfGenerator {
  static Future<void> generateAndDownload(Profile profile) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  profile.name,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                if (profile.bio != null) pw.Text(profile.bio!, style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),

                pw.Text(
                  'Skills',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Bullet(text: profile.skills.join(', ')),
                pw.SizedBox(height: 20),

                pw.Text(
                  'Education',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(profile.education ?? 'Not provided'),
                pw.SizedBox(height: 20),

                pw.Text(
                  'Experience',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(profile.experience ?? 'Not provided'),
                pw.SizedBox(height: 20),

                pw.Text(
                  'Projects',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(profile.projects ?? 'Not provided'),
                pw.SizedBox(height: 20),

                if ((profile.githubUrl?.isNotEmpty ?? false) ||
                    (profile.linkedinUrl?.isNotEmpty ?? false)) ...[
                  pw.Divider(),
                  pw.SizedBox(height: 10),

                  if (profile.githubUrl?.isNotEmpty ?? false)
                    pw.Text('GitHub: ${profile.githubUrl}'),

                  if (profile.linkedinUrl?.isNotEmpty ?? false)
                    pw.Text('LinkedIn: ${profile.linkedinUrl}'),
                ],
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
