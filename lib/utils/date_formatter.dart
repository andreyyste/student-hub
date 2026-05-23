import 'package:flutter/material.dart';

String formatWaktu(DateTime deadline) {
  final sekarang = DateTime.now();
  final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
  final hariTugas = DateTime(deadline.year, deadline.month, deadline.day);

  final selisihHari = hariTugas.difference(hariIni).inDays;

  final jam =
      "${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}";

  if (selisihHari == 0) {
    return "Hari ini jam $jam";
  } else if (selisihHari == 1) {
    return "Besok jam $jam";
  } else if (selisihHari == 2) {
    return "Lusa jam $jam";
  } else {
    return "Tanggal ${deadline.day}/${deadline.month} jam $jam";
  }
}
