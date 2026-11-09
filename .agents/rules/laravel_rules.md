# Aturan Khusus Laravel / Web Development

Aturan ini berlaku setiap kali kamu mengerjakan tugas yang berkaitan dengan Laravel / Web.

---

## Arsitektur & Struktur

Ikuti konvensi standar Laravel dengan tambahan organisasi yang lebih rapi:

```
app/
├── Http/
│   ├── Controllers/
│   │   └── Api/              # Controller khusus API (jika ada)
│   ├── Middleware/
│   ├── Requests/             # Form Request Validation (WAJIB!)
│   └── Resources/            # API Resource / Transformer
├── Models/                   # Eloquent Models
├── Services/                 # Business Logic Layer
├── Repositories/             # Data Access Layer (opsional, untuk proyek besar)
├── Enums/                    # PHP Enums
├── Events/                   # Event classes
├── Listeners/                # Event listeners
├── Policies/                 # Authorization policies
└── Exceptions/               # Custom exceptions

database/
├── migrations/
├── factories/                # WAJIB dibuat untuk setiap model
└── seeders/

tests/
├── Feature/                  # Feature/integration tests
└── Unit/                     # Unit tests

resources/
├── views/
│   ├── layouts/
│   ├── components/           # Blade components
│   └── <nama_fitur>/
├── css/
└── js/
```

## Konvensi Penamaan
- Model: `PascalCase` singular (contoh: `Product`, `OrderItem`)
- Controller: `PascalCase` + `Controller` (contoh: `ProductController`)
- Migration: otomatis dari artisan
- Table: `snake_case` plural (contoh: `products`, `order_items`)
- Form Request: `PascalCase` + `Request` (contoh: `StoreProductRequest`)
- Seeder: `PascalCase` + `Seeder` (contoh: `ProductSeeder`)
- Factory: `PascalCase` + `Factory` (contoh: `ProductFactory`)

## Validasi
- **SELALU** gunakan Form Request class, JANGAN validasi langsung di controller.
- Contoh: `php artisan make:request StoreProductRequest`
- Tambahkan pesan error dalam bahasa Indonesia jika user meminta.

## Database & Eloquent
- Selalu definisikan `$fillable` atau `$guarded` di setiap model.
- Definisikan semua relationship di model (hasMany, belongsTo, dll).
- Gunakan `$casts` untuk tipe data khusus (date, boolean, enum, json).
- Selalu buat Factory dan Seeder untuk setiap model baru.
- Gunakan database transaction untuk operasi yang melibatkan multiple table.

## Auto-Testing Laravel
Setiap kali membuat fitur baru (terutama CRUD):
1. **Buat Factory** untuk model terkait.
2. **Buat Feature Test** yang mencakup:
   - Test index (list data)
   - Test store (create data) - valid & invalid input
   - Test show (detail data)
   - Test update (edit data) - valid & invalid input
   - Test destroy (delete data)
   - Test authorization (jika ada policy)
3. **Jalankan test**: `php artisan test --filter=NamaTest`
4. Jika gagal, perbaiki sampai semua test HIJAU.
5. Jalankan juga: `php artisan route:list` untuk verifikasi routing.

## Service Layer
- Untuk logika bisnis yang kompleks, buat Service class di `app/Services/`.
- Controller hanya bertugas: terima request → panggil service → return response.
- Jangan taruh business logic di controller.

## API Development (Jika Diminta)
- Selalu gunakan API Resource untuk format response.
- Response format standar:
```json
{
  "success": true,
  "message": "Data berhasil diambil",
  "data": { }
}
```
- Gunakan proper HTTP status codes (200, 201, 404, 422, 500).
- Implementasi API versioning: `/api/v1/...`

## Frontend (Blade/Livewire/Filament)
- Jika user menggunakan **Filament**, ikuti konvensi Filament sepenuhnya.
- Jika user menggunakan **Blade biasa**, gunakan Blade Components untuk reusability.
- Jika user menggunakan **Livewire**, pisahkan component per fitur.

## Keamanan Laravel
- Selalu gunakan Policy untuk authorization, jangan cek manual di controller.
- Gunakan `Gate` atau `@can` directive di Blade.
- Escape semua output di Blade (gunakan `{{ }}` bukan `{!! !!}` kecuali memang perlu).
- Gunakan CSRF protection (sudah default di Laravel).

## Packages Standar
- Admin Panel: `filament/filament` (jika diminta)
- Debug: `barryvdh/laravel-debugbar` (dev only)
- IDE Helper: `barryvdh/laravel-ide-helper` (dev only)
- Spatie packages sesuai kebutuhan (permission, media-library, dll)
