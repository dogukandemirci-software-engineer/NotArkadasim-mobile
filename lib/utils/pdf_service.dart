import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  Future<void> savePdf(String text, String fileName) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.albertSansItalic();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Text(
          text,
          style: pw.TextStyle(font: font, fontSize: 14),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: "$fileName.pdf",
    );
  }
}
