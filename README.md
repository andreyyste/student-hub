# 🎓 Student Hub UGM - Task & Schedule Tracker

Aplikasi *mobile* berbasis **Flutter** yang dibikin khusus buat ngebantu mahasiswa (khususnya UGM) biar idupnya lebih tertata. App ini bisa nyatet tugas, ngatur jadwal kuliah per semester, sampe buka portal eLOK langsung dari dalem *app*!

## ✨ Fitur Utama

- 📊 **Smart Dashboard**: Nampilin tugas yang *deadline*-nya paling mepet dan jadwal kelas selanjutnya hari ini.
- 📝 **Manajemen Tugas (SQLite)**: Tambah, liat, dan centang tugas kalau udah kelar. Gak ada lagi cerita lupa *submit* tugas.
- 🗓️ **Jadwal Kuliah Fleksibel**: 
  - Filter jadwal berdasarkan semester.
  - Fitur *toggle* buat nandain **Kelas Pengganti** atau **Kelas Dibatalkan** (dosen kos).
- 🌐 **Portal eLOK Terintegrasi**:
  - *Browser in-app* buat buka `elok.ugm.ac.id`.
  - **Smart PDF Reader**: Kalau ngeklik materi PDF di eLOK, *app* bakal otomatis ngambil *cookie* login dan ngebuka PDF-nya langsung pake *viewer* bawaan, gak perlu *download* pihak ketiga!
  - *Support download* materi langsung ke HP.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Database**: [sqflite](https://pub.dev/packages/sqflite) (Local SQLite Database)
- **WebView**: [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)
- **PDF Viewer**: [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer)
- **URL Launcher**: [url_launcher](https://pub.dev/packages/url_launcher)

## 📂 Struktur Folder

Kode udah dipecah biar gampang buat di-*maintain* dan di-*scale*:

```text
lib/
├── database_helper.dart        # Konfigurasi & fungsi CRUD SQLite
├── main.dart                   # Entry point & Dashboard UI
├── models/
│   ├── class_schedule.dart     # Model data jadwal
│   └── student_task.dart       # Model data tugas
└── screens/
    ├── add_edit_schedule_screen.dart
    ├── add_task_screen.dart
    ├── elok_portal_screen.dart # In-App WebView buat eLOK
    ├── pdf_viewer_screen.dart  # Custom PDF Viewer dengan injeksi Cookie
    ├── schedule_screen.dart
    └── view_tasks_screen.dart
