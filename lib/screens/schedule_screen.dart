import 'package:flutter/material.dart';
import '../models/class_schedule.dart';
import '../services/database_helper.dart';
import '../widgets/schedule_card.dart';
import 'add_edit_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<ClassSchedule> mySchedule = [];
  bool _isLoading = true;
  String _activeSemester = "Semester 2";

  final List<String> _semesters = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
    "Semester 7",
    "Semester 8",
  ];

  @override
  void initState() {
    super.initState();
    _refreshSchedules();
  }

  /// Mengambil data jadwal kelas terbaru dari database berdasarkan semester yang sedang aktif.
  Future<void> _refreshSchedules() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getSchedulesBySemester(
      _activeSemester,
    );
    setState(() {
      mySchedule = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Membangun navigasi berbasis tab (TabBar) yang menampung 5 hari kerja (Senin - Jumat)
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _activeSemester,
              dropdownColor: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              items: _semesters.map((String sem) {
                return DropdownMenuItem<String>(value: sem, child: Text(sem));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _activeSemester = newValue);
                  _refreshSchedules();
                }
              },
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Senin"),
              Tab(text: "Selasa"),
              Tab(text: "Rabu"),
              Tab(text: "Kamis"),
              Tab(text: "Jumat"),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildDaySchedule("Senin"),
                  _buildDaySchedule("Selasa"),
                  _buildDaySchedule("Rabu"),
                  _buildDaySchedule("Kamis"),
                  _buildDaySchedule("Jumat"),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddEditScheduleScreen(defaultSemester: _activeSemester),
              ),
            );
            _refreshSchedules();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Membangun antarmuka representasi daftar jadwal berdasarkan input hari (Senin, Selasa, dsb.).
  Widget _buildDaySchedule(String day) {
    // Memfilter data jadwal keseluruhan dengan kecocokan pada variabel "hari" yang spesifik
    final todaySchedule = mySchedule.where((s) => s.day == day).toList();

    if (todaySchedule.isEmpty) {
      return Center(
        child: Text(
          "Kosong nih hari $day, gas ngopi!",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: todaySchedule.length,
      itemBuilder: (context, index) {
        final item = todaySchedule[index];
        final isBatal = item.isCancelled;

        return ScheduleCard(
          item: item,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditScheduleScreen(
                  schedule: item,
                  defaultSemester: _activeSemester,
                ),
              ),
            );
            _refreshSchedules();
          },
        );
      },
    );
  }
}