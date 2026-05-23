import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../services/database_helper.dart';
import '../widgets/save_pdf_dialog.dart'; 
import '../models/student_task.dart';

class PdfViewerScreen extends StatefulWidget {
  final String? pdfUrl;
  final String? cookie;
  final String? localPath; 

  const PdfViewerScreen({
    super.key,
    this.pdfUrl,
    this.cookie,
    this.localPath,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool isDownloading = false;

  // Status internal
  double _downloadProgress = 0.0;

  /// Mengelola proses pengunduhan PDF ke memori fisik (Storage) dan menyimpan rekamannya di basis data
  Future<void> _downloadAndSavePdf(String type, String title, String course, DateTime? deadline, String category) async {
    if (widget.pdfUrl == null || widget.cookie == null) return;

    setState(() {
      isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      String cleanTitle = title.replaceAll(' ', '_');
      String fileName = "${cleanTitle}_${DateTime.now().millisecondsSinceEpoch}.pdf";
      String savePath = "${dir.path}/$fileName";

      var dio = Dio();
      await dio.download(
        widget.pdfUrl!,
        savePath,
        options: Options(headers: {'Cookie': widget.cookie}),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (type == 'tugas') {
        final newTask = StudentTask(
          title: title,
          course: course,
          deadline: deadline!, 
          filePath: savePath, 
        );
        
        await DatabaseHelper.instance.insertTask(newTask);
        
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Tugas beserta PDF berhasil disimpan!")),
           );
        }

      } else if (type == 'materi') {
        await DatabaseHelper.instance.insertMaterial(
          title, 
          course, 
          category, 
          savePath
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Materi offline berhasil disimpan!")),
          );
        }
      }

    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Gagal download: $e")),
         );
      }
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  /// Menampilkan dialog form dengan field sesuai dengan jenis dokumen yang disimulasikan sebagai parameter tipe (misalnya `materi` atau `tugas`)
  void _showDownloadDialog(String type) {
    showDialog(
      context: context,
      builder: (context) {
        return SavePdfDialog(
          type: type,
          onSave: (title, course, deadline, category) {
            _downloadAndSavePdf(type, title, course, deadline, category);
          },
        );
      },
    );
  }

  void _showSaveOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Simpan sebagai Tugas'),
              onTap: () {
                Navigator.pop(context);
                _showDownloadDialog('tugas'); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Simpan sebagai Materi'),
              onTap: () {
                Navigator.pop(context);
                _showDownloadDialog('materi'); 
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLocal = widget.localPath != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isLocal ? "Dokumen Lokal" : "Materi eLOK", style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF4A00E0),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          isLocal
              ? SfPdfViewer.file(File(widget.localPath!))
              : SfPdfViewer.network(widget.pdfUrl!, headers: {'Cookie': widget.cookie!}),
          if (isDownloading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isLocal
          ? null
          : FloatingActionButton(
              onPressed: isDownloading ? null : _showSaveOptions,
              backgroundColor: const Color(0xFF4A00E0),
              child: const Icon(Icons.download, color: Colors.white),
            ),
    );
  }
}