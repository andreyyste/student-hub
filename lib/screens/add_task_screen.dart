import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/student_task.dart';
import '../services/database_helper.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDeadline;
  
  // Variabel untuk menyimpan jalur (path) file PDF secara lokal
  String? _selectedFilePath; 

  /// Membuka dialog kalender dan waktu untuk memilih batas waktu tugas (deadline).
  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  /// Membuka sistem pengelola file perangkat untuk mengunggah dokumen berekstensi PDF.
  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Tugas")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Nama Tugas"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(labelText: "Matkul"),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                _selectedDeadline == null
                    ? "Pilih Deadline"
                    : "${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDeadline,
              tileColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            
            // Tombol untuk menginisiasi pemilihan file PDF lampiran tugas
            OutlinedButton.icon(
              onPressed: _pickPdf,
              icon: const Icon(Icons.attach_file),
              label: Text(
                _selectedFilePath == null 
                  ? "Tambahkan PDF (Opsional)" 
                  // Mengekstrak dan menampilkan nama file dari jalur (path) keseluruhan
                  : _selectedFilePath!.split('/').last, 
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                alignment: Alignment.centerLeft,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                // Memastikan judul dan batas waktu telah terisi sebelum menyimpan ke database
                if (_titleController.text.isNotEmpty &&
                    _selectedDeadline != null) {
                  final newTask = StudentTask(
                    title: _titleController.text,
                    course: _courseController.text,
                    deadline: _selectedDeadline!,
                    filePath: _selectedFilePath, // Menyertakan path file lokal ke dalam objek model
                  );
                  await DatabaseHelper.instance.insertTask(newTask);

                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text("Simpan Database"),
            ),
          ],
        ),
      ),
    );
  }
}