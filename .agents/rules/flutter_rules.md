# Aturan Khusus Flutter / Mobile Development

Aturan ini berlaku setiap kali kamu mengerjakan tugas yang berkaitan dengan Flutter / Mobile.

---

## Arsitektur & Struktur Folder

Gunakan arsitektur yang bersih dan terstruktur:

```
lib/
├── main.dart
├── app/
│   ├── routes/              # Routing (GoRouter / AutoRoute)
│   └── theme/               # ThemeData, warna, tipografi
├── core/
│   ├── constants/           # Konstanta aplikasi
│   ├── errors/              # Custom exceptions & failures
│   ├── network/             # Dio client, interceptors
│   └── utils/               # Helper functions
├── features/
│   └── <nama_fitur>/
│       ├── data/
│       │   ├── datasources/  # Remote & Local data sources
│       │   ├── models/       # Model (fromJson/toJson)
│       │   └── repositories/ # Implementasi repository
│       ├── domain/
│       │   ├── entities/     # Entity murni (tanpa dependency)
│       │   ├── repositories/ # Abstract repository (contract)
│       │   └── usecases/     # Business logic per use case
│       └── presentation/
│           ├── bloc/         # atau provider/cubit
│           ├── pages/        # Halaman utama
│           └── widgets/      # Widget reusable per fitur
└── shared/
    └── widgets/              # Widget global yang dipakai banyak fitur
```

## Konvensi Penamaan
- File: `snake_case.dart` (contoh: `product_repository.dart`)
- Class: `PascalCase` (contoh: `ProductRepository`)
- Variable/Function: `camelCase` (contoh: `getProductById`)
- Konstanta: `camelCase` dengan prefix `k` (contoh: `kPrimaryColor`)

## State Management
- Default gunakan **BLoC/Cubit** kecuali user meminta yang lain.
- Selalu pisahkan state, event, dan bloc ke file terpisah jika sudah kompleks.

## Dependency Injection
- Gunakan **get_it** + **injectable** untuk DI.
- Register semua dependency di file `injection_container.dart`.

## Networking
- Gunakan **Dio** untuk HTTP requests.
- Selalu buat interceptor untuk:
  - Logging request/response
  - Token refresh otomatis
  - Error handling global

## Auto-Testing Flutter
Setiap kali membuat fitur baru:
1. **Unit Test**: Test semua use case dan repository.
2. **Widget Test**: Test widget/page utama.
3. Jalankan: `flutter test`
4. Jika ada test gagal, perbaiki kode sampai semua test lolos.
5. Jalankan juga `dart analyze` untuk memastikan tidak ada warning.

## UI/UX Standards
- Selalu gunakan `Theme.of(context)` untuk warna dan tipografi, jangan hardcode.
- Implementasi responsive design menggunakan `MediaQuery` atau `LayoutBuilder`.
- Gunakan `const` constructor sedapat mungkin untuk optimasi performa.
- Selalu tambahkan loading state, empty state, dan error state di setiap halaman.

## Packages Standar (Gunakan Kecuali User Meminta Lain)
- State Management: `flutter_bloc`
- Routing: `go_router`
- Network: `dio`
- DI: `get_it`, `injectable`
- Local Storage: `shared_preferences` atau `hive`
- Serialization: `json_serializable`, `freezed`
