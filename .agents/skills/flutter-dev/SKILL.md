---
name: flutter-dev
description: >-
  Gunakan skill ini ketika user meminta membuat fitur mobile, Flutter, Android, iOS,
  widget, atau hal apapun yang berkaitan dengan pengembangan aplikasi mobile menggunakan
  Flutter dan Dart. Skill ini berisi prosedur lengkap mulai dari setup proyek, pembuatan
  fitur CRUD, integrasi API, hingga auto-testing.
---

# Flutter Development Skill

Skill ini adalah panduan lengkap untuk mengembangkan aplikasi mobile menggunakan Flutter.

---

## 🚀 Alur Kerja: Setup Proyek Baru

Jika user meminta membuat proyek Flutter baru:

1. **Cek Flutter SDK**:
   ```bash
   flutter --version
   flutter doctor
   ```
2. **Buat proyek baru**:
   ```bash
   flutter create --org com.namauser nama_proyek
   cd nama_proyek
   ```
3. **Setup struktur folder** sesuai `flutter_rules.md` (Clean Architecture).
4. **Install core packages**:
   ```bash
   flutter pub add flutter_bloc go_router dio get_it injectable shared_preferences json_annotation equatable
   flutter pub add --dev build_runner json_serializable injectable_generator flutter_lints
   ```
5. **Setup tema dasar** di `lib/app/theme/`.
6. **Setup routing** di `lib/app/routes/`.
7. **Setup DI** di `lib/core/injection_container.dart`.
8. **Verifikasi**: Jalankan `flutter run` atau `flutter build apk --debug` untuk memastikan tidak ada error.

---

## 📝 Alur Kerja: Membuat Fitur CRUD Baru

Setiap kali user meminta membuat fitur/modul baru (misal: "buatkan fitur manajemen produk"), ikuti langkah ini **secara berurutan dan otomatis**:

### Langkah 1: Buat Struktur Fitur
```
lib/features/<nama_fitur>/
├── data/
│   ├── datasources/
│   │   ├── <nama>_remote_datasource.dart
│   │   └── <nama>_local_datasource.dart
│   ├── models/
│   │   └── <nama>_model.dart          # dengan fromJson/toJson
│   └── repositories/
│       └── <nama>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <nama>.dart                 # Entity murni
│   ├── repositories/
│   │   └── <nama>_repository.dart      # Abstract class
│   └── usecases/
│       ├── get_<nama>s.dart
│       ├── get_<nama>_by_id.dart
│       ├── create_<nama>.dart
│       ├── update_<nama>.dart
│       └── delete_<nama>.dart
└── presentation/
    ├── bloc/
    │   ├── <nama>_bloc.dart
    │   ├── <nama>_event.dart
    │   └── <nama>_state.dart
    ├── pages/
    │   ├── <nama>_list_page.dart
    │   ├── <nama>_detail_page.dart
    │   └── <nama>_form_page.dart
    └── widgets/
        ├── <nama>_card.dart
        └── <nama>_form.dart
```

### Langkah 2: Implementasi Layer-by-Layer
1. **Entity** → Model → DataSource → Repository Implementation
2. **Use Cases** (setiap use case = 1 class, 1 method `call()`)
3. **BLoC/Cubit** (handle semua state: loading, loaded, error, empty)
4. **Pages & Widgets**

### Langkah 3: Register di DI
- Tambahkan semua class baru ke `injection_container.dart`.

### Langkah 4: Tambahkan Route
- Daftarkan halaman baru di router.

### Langkah 5: AUTO-TEST (WAJIB, JANGAN SKIP!)
1. Buat file test:
   ```
   test/features/<nama_fitur>/
   ├── data/
   │   ├── models/<nama>_model_test.dart
   │   └── repositories/<nama>_repository_impl_test.dart
   ├── domain/
   │   └── usecases/
   │       ├── get_<nama>s_test.dart
   │       └── create_<nama>_test.dart
   └── presentation/
       └── bloc/<nama>_bloc_test.dart
   ```
2. Jalankan test:
   ```bash
   flutter test
   ```
3. Jika ada test GAGAL:
   - Analisis error message
   - Perbaiki kode
   - Jalankan ulang test
   - Ulangi sampai SEMUA test PASSED
4. Jalankan linting:
   ```bash
   dart analyze
   dart format lib/ test/
   ```

### Langkah 6: Lapor ke User
Baru setelah SEMUA langkah di atas selesai dan semua test PASSED, lapor ke user dengan format:

```
✅ Fitur [Nama Fitur] selesai dibuat!

📁 File yang dibuat:
- lib/features/nama_fitur/... (X files)
- test/features/nama_fitur/... (Y files)

🧪 Hasil Test:
- X tests passed, 0 failed
- dart analyze: no issues found

🔗 Route: /nama-fitur
```

---

## 🔌 Alur Kerja: Integrasi API

Ketika user meminta koneksi ke backend/API:

1. Buat atau update `base_url` di constants / `.env`.
2. Buat Dio client di `core/network/` dengan interceptor.
3. Implementasi remote data source dengan endpoint yang benar.
4. Test koneksi API.
5. Handle semua kemungkinan error (timeout, 401, 404, 500, no internet).

---

## 🎨 Alur Kerja: UI/UX

Ketika membuat UI:
1. Selalu gunakan ThemeData, jangan hardcode warna/font.
2. Implementasi 3 state di setiap halaman: **Loading**, **Data/Empty**, **Error**.
3. Tambahkan animasi transisi antar halaman.
4. Pastikan responsive di berbagai ukuran layar.
5. Gunakan `const` constructor sebanyak mungkin.

---

## ⚠️ Hal yang TIDAK BOLEH Dilakukan
- ❌ Taruh business logic di widget/page
- ❌ Import file dari layer `data` di layer `presentation` secara langsung
- ❌ Hardcode string, warna, atau ukuran
- ❌ Skip pembuatan test
- ❌ Buat model tanpa fromJson/toJson
- ❌ Biarkan `dart analyze` menunjukkan warning tanpa diperbaiki
