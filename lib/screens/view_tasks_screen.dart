import 'package:flutter/material.dart';
import '../models/student_task.dart';
import '../database_helper.dart';

class ViewTasksScreen extends StatefulWidget {
  const ViewTasksScreen({super.key});

  @override
  State<ViewTasksScreen> createState() => _ViewTasksScreenState();
}

class _ViewTasksScreenState extends State<ViewTasksScreen> {
  List<StudentTask> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    final tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Tugas Gua")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
          ? const Center(child: Text("Belum ada tugas, aman lur!"))
          : ListView.builder(
              itemCount: _tasks.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final item = _tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.book)),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${item.course} • ${item.deadline.day}/${item.deadline.month}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteTask(item.id!);
                        _refreshTasks();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Tugas Selesai! GGWP.")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
