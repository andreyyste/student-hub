import 'package:flutter/material.dart';
import '../models/student_task.dart';
import '../models/class_schedule.dart';

StudentTask? getNearestTask(List<StudentTask> tasks) {
  if (tasks.isEmpty) return null;
  return tasks.first;
}

ClassSchedule? getNearestSchedule(List<ClassSchedule> schedules) {
  if (schedules.isEmpty) return null;

  List<String> hari = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];
  String hariIni = hari[DateTime.now().weekday - 1];

  var jadwalHariIni = schedules
      .where((s) => s.day == hariIni && !s.isCancelled)
      .toList();
  if (jadwalHariIni.isEmpty) return null;

  jadwalHariIni.sort((a, b) => a.startTime.compareTo(b.startTime));

  final now = TimeOfDay.now();
  final nowInMinutes = (now.hour * 60) + now.minute;

  for (var jadwal in jadwalHariIni) {
    final endParts = jadwal.endTime.split(":");
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);
    final endInMinutes = (endHour * 60) + endMinute;
    if (nowInMinutes <= endInMinutes) {
      return jadwal;
    }
  }

  return null;
}
