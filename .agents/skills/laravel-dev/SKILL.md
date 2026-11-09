---
name: laravel-dev
description: >-
  Gunakan skill ini ketika user meminta membuat fitur web, Laravel, PHP, Blade, Livewire,
  Filament, migration, API backend, atau hal apapun yang berkaitan dengan pengembangan
  web menggunakan Laravel. Skill ini berisi prosedur lengkap mulai dari setup proyek,
  pembuatan fitur CRUD, API development, hingga auto-testing.
---

# Laravel Development Skill

Skill ini adalah panduan lengkap untuk mengembangkan aplikasi web menggunakan Laravel.

---

## 🚀 Alur Kerja: Setup Proyek Baru

Jika user meminta membuat proyek Laravel baru:

1. **Cek PHP & Composer**:
   ```bash
   php --version
   composer --version
   ```
2. **Buat proyek baru**:
   ```bash
   composer create-project laravel/laravel nama_proyek
   cd nama_proyek
   ```
3. **Setup database** di `.env`:
   - Default gunakan SQLite untuk kemudahan development
   - Atau MySQL/PostgreSQL jika user meminta
4. **Jalankan migration awal**:
   ```bash
   php artisan migrate
   ```
5. **Install dev packages**:
   ```bash
   composer require --dev barryvdh/laravel-debugbar barryvdh/laravel-ide-helper
   ```
6. **Jika user meminta Filament**:
   ```bash
   composer require filament/filament
   php artisan filament:install --panels
   ```
7. **Verifikasi**: Jalankan `php artisan serve` dan pastikan halaman welcome muncul.

---

## 📝 Alur Kerja: Membuat Fitur CRUD Baru

Setiap kali user meminta membuat fitur/modul baru (misal: "buatkan CRUD produk"), ikuti langkah ini **secara berurutan dan otomatis**:

### Langkah 1: Buat Model + Migration + Factory + Seeder
```bash
php artisan make:model NamaModel -mfs
```
- `-m` = migration
- `-f` = factory
- `-s` = seeder

**Implementasi Migration:**
- Definisikan semua kolom yang diperlukan
- Tambahkan foreign key jika ada relasi
- Tambahkan index untuk kolom yang sering di-query

**Implementasi Model:**
- Set `$fillable` / `$guarded`
- Set `$casts` untuk tipe data khusus
- Definisikan semua relationship
- Tambahkan scope jika diperlukan

**Implementasi Factory:**
- Gunakan Faker untuk generate data realistis
- Cover semua kolom fillable

**Implementasi Seeder:**
- Buat minimal 10-20 data dummy

### Langkah 2: Jalankan Migration & Seeder
```bash
php artisan migrate
php artisan db:seed --class=NamaSeeder
```

### Langkah 3: Buat Form Request Validation
```bash
php artisan make:request StoreNamaRequest
php artisan make:request UpdateNamaRequest
```
- Definisikan rules yang lengkap dan ketat
- Tambahkan custom message jika perlu
- Set `authorize()` return `true` (atau implementasi authorization logic)

### Langkah 4: Buat Service (Jika Logic Kompleks)
- Buat `app/Services/NamaService.php`
- Pindahkan semua business logic ke sini
- Controller hanya menjadi "traffic controller"

### Langkah 5: Buat Controller
```bash
php artisan make:controller NamaController --resource
```
Atau untuk API:
```bash
php artisan make:controller Api/NamaController --api
```

Implementasi semua method:
- `index()` - List dengan pagination
- `create()` - Form create (web) 
- `store()` - Simpan data baru (gunakan Form Request)
- `show()` - Detail data
- `edit()` - Form edit (web)
- `update()` - Update data (gunakan Form Request)
- `destroy()` - Hapus data (soft delete jika perlu)

### Langkah 6: Buat Views (Blade) atau Resource (API)

**Jika Web (Blade):**
```
resources/views/<nama>/
├── index.blade.php     # Tabel dengan pagination
├── create.blade.php    # Form tambah
├── show.blade.php      # Detail
└── edit.blade.php      # Form edit
```

**Jika Filament:**
```bash
php artisan make:filament-resource Nama --generate
```

**Jika API:**
```bash
php artisan make:resource NamaResource
php artisan make:resource NamaCollection
```

### Langkah 7: Daftarkan Route
- Web: tambahkan di `routes/web.php`
- API: tambahkan di `routes/api.php`
```php
Route::resource('namas', NamaController::class);
// atau
Route::apiResource('namas', NamaController::class);
```

### Langkah 8: AUTO-TEST (WAJIB, JANGAN SKIP!)

1. **Buat Feature Test**:
   ```bash
   php artisan make:test NamaTest
   ```

2. **Implementasi test cases** (MINIMUM ini semua harus ada):
   ```php
   // tests/Feature/NamaTest.php
   
   /** @test */
   public function it_can_list_all_items()
   /** @test */
   public function it_can_create_a_new_item()
   /** @test */
   public function it_validates_required_fields_on_create()
   /** @test */
   public function it_can_show_a_single_item()
   /** @test */
   public function it_can_update_an_item()
   /** @test */
   public function it_validates_required_fields_on_update()
   /** @test */
   public function it_can_delete_an_item()
   ```

3. **Jalankan test**:
   ```bash
   php artisan test --filter=NamaTest
   ```

4. **Jika ada test GAGAL**:
   - Baca error message dengan teliti
   - Perbaiki kode (bukan test-nya, kecuali memang test yang salah)
   - Jalankan ulang
   - Ulangi sampai **SEMUA test PASSED**

5. **Verifikasi route**:
   ```bash
   php artisan route:list --name=nama
   ```

### Langkah 9: Lapor ke User
Baru setelah SEMUA langkah di atas selesai dan semua test PASSED, lapor ke user:

```
✅ CRUD [Nama Fitur] selesai dibuat!

📁 File yang dibuat:
- Model: app/Models/Nama.php
- Migration: database/migrations/xxxx_create_namas_table.php
- Controller: app/Http/Controllers/NamaController.php
- Requests: StoreNamaRequest, UpdateNamaRequest
- Views: resources/views/nama/ (4 files)
- Factory & Seeder: ✓
- Test: tests/Feature/NamaTest.php

🧪 Hasil Test:
- 7 tests, 15 assertions - ALL PASSED ✅

🔗 Routes:
- GET    /namas          → index
- POST   /namas          → store
- GET    /namas/{id}     → show
- PUT    /namas/{id}     → update
- DELETE /namas/{id}     → destroy
```

---

## 🔌 Alur Kerja: API Development

Ketika user meminta membuat API:
1. Gunakan API Resource untuk transformasi data.
2. Implementasi response wrapper yang konsisten.
3. Gunakan proper HTTP status codes.
4. Tambahkan API versioning (`/api/v1/...`).
5. Dokumentasikan endpoint (minimal di README atau komentar di route).
6. Test semua endpoint dengan Feature Test.

---

## 🔐 Alur Kerja: Authentication

Ketika user meminta auth:
1. **Web**: Gunakan Laravel Breeze atau Fortify.
2. **API**: Gunakan Laravel Sanctum.
3. Selalu buat Policy untuk authorization.
4. Test login, register, dan protected routes.

---

## 📊 Alur Kerja: Relasi Antar Model

Ketika menambahkan relasi:
1. Definisikan relationship di KEDUA sisi model.
2. Update migration jika perlu foreign key.
3. Update Factory agar bisa generate data berelasi.
4. Update test untuk cover relasi.
5. Gunakan eager loading (`with()`) untuk hindari N+1 query.

---

## ⚠️ Hal yang TIDAK BOLEH Dilakukan
- ❌ Validasi langsung di controller (harus pakai Form Request)
- ❌ Query langsung di controller tanpa model/scope
- ❌ Lupa membuat Factory dan Seeder
- ❌ Skip pembuatan test
- ❌ Hardcode credentials di kode
- ❌ Return response tanpa proper HTTP status code
- ❌ Lupa menambahkan `$fillable` di model
- ❌ Raw query tanpa parameter binding (SQL injection risk)
