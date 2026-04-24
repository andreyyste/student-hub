import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String cookie;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.cookie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Materi Kuliah", style: TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF4A00E0),
        foregroundColor: Colors.white,
      ),
      body: SfPdfViewer.network(pdfUrl, headers: {'Cookie': cookie}),
    );
  }
}
