import 'package:flutter/material.dart';
import '../models/student_task.dart';
import '../database_helper.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDeadline;

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
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _selectedDeadline != null) {
                  final newTask = StudentTask(
                    title: _titleController.text,
                    course: _courseController.text,
                    deadline: _selectedDeadline!,
                  );
                  await DatabaseHelper.instance.insertTask(newTask);

                  Navigator.pop(context);
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
