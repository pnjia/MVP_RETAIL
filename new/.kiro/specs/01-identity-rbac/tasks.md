d# Tasks Specification: Identity & Role-Based Access Control (identity-rbac)

## 1. Overview
Rencana implementasi ini dirancang secara bertahap (incremental) untuk memigrasikan database Supabase MangRitel ke arsitektur RBAC penuh. Semua tugas berfokus pada eksekusi kode database (DDL, DML, SQL functions) dan pengujian keamanan RLS tanpa ada downtime atau data loss untuk record yang ada.

## 2. Task List

### Tahap 1: Pembuatan Tabel RBAC Baru
- [x] 1.1 Buat skema tabel `permissions` dan `roles` dengan constraint yang sesuai.
  - Implementasikan tabel `permissions` (code, description, audit standar).
  - Implementasikan tabel `roles` (name, business_id, uuid, audit standar) dengan UNIQUE constraint `(business_id, name)`.
  - _Requirements: REQ-1_
- [x] 1.2 Buat tabel relasi `role_permissions` dan `user_roles`.
  - Implementasikan `role_permissions` dengan Primary Key composite `(role_id, permission_id)`.
  - Implementasikan `user_roles` dengan surrogate key `id` dan Composite Unique Index `idx_user_roles_unique` menggunakan `COALESCE(outlet_id, -1)` untuk mengakomodasi nilai `NULL` (berlaku di semua outlet).
  - _Requirements: REQ-2_
- [x] 1.3 Aktifkan RLS pada seluruh tabel baru.
  - Jalankan `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;` untuk `permissions`, `roles`, `role_permissions`, dan `user_roles`.
  - _Requirements: REQ-6_

### Tahap 2: Implementasi Fungsi Otorisasi (Helper Functions)
- [x] 2.1 Buat fungsi database `public.has_permission`.
  - Input: `p_permission_code VARCHAR`, `p_outlet_id BIGINT` (nullable).
  - Return: `BOOLEAN`.
  - Logic: Query `user_roles` dan `role_permissions` berdasarkan `auth.uid()` yang dicocokkan ke `users.uuid`. Jika user memiliki role dengan `name = 'Owner'` pada bisnis tersebut, otomatis return `TRUE` (bypass).
  - Pastikan fungsi menggunakan `SECURITY DEFINER` untuk menghindari loop rekursif RLS pada tabel `users`.
  - _Requirements: REQ-4, REQ-6_

### Tahap 3: Seeding & Migrasi Data Legacy
- [x] 3.1 Lakukan seeding awal untuk data permissions dan roles dasar.
  - Masukkan daftar permission standar (mis. `PRODUCT_CREATE`, `SALE_VOID`, `CRM_CREATE`, `PURCHASE_APPROVE`).
  - Masukkan role default sistem global (Owner, Administrator, Kasir, Gudang).
  - Hubungkan permission default ke masing-masing role di tabel `role_permissions`.
  - _Requirements: REQ-1, REQ-2_
- [x] 3.2 Migrasikan peran dari kolom ENUM legacy ke tabel RBAC baru.
  - Tulis kueri DML untuk membaca kolom `users.role` lama (Owner, Administrator, Kasir) dan melakukan insert otomatis ke `user_roles` dengan menghubungkan user ke role baru yang bersesuaian.
  - _Requirements: REQ-3_
- [x] 3.3 Hapus kolom `role` lama pada tabel `users`.
  - Jalankan `ALTER TABLE public.users DROP COLUMN role;` setelah proses verifikasi data migrasi berhasil.
  - _Requirements: REQ-3_

### Tahap 4: Penerapan RLS Policies pada RBAC
- [x] 4.1 Terapkan kebijakan akses (RLS Policies) pada tabel-tabel RBAC.
  - Buat policy SELECT/INSERT/UPDATE/DELETE untuk `roles` dan `user_roles` yang memanfaatkan `get_auth_business_id()` agar hanya bisa dimodifikasi oleh user dalam satu tenant bisnis.
  - Buat policy SELECT untuk tabel `permissions` agar bisa dibaca oleh semua user terautentikasi.
  - _Requirements: REQ-6_

## 3. Quality Gates
- [ ] Seluruh tabel baru (`permissions`, `roles`, `role_permissions`, `user_roles`) terbuat di Supabase dengan tipe data dan foreign key yang tepat.
- [ ] Fungsi `public.has_permission` berhasil diuji dan mengembalikan nilai boolean yang benar untuk user global maupun user spesifik outlet.
- [ ] Kolom `role` legacy pada tabel `users` berhasil dihapus tanpa merusak integritas data user.
- [ ] Pengujian RLS memverifikasi bahwa tenant A sama sekali tidak bisa membaca data role/permission dari tenant B.

## 4. Implementation Sequence
Kita memulai dengan membuat struktur tabel baru (**Tahap 1**) agar database memiliki wadah data yang valid. Setelah struktur siap, fungsi logika otorisasi (`has_permission`) dibuat pada **Tahap 2**. Data master sistem diisi dan user lama dipindahkan ke struktur baru pada **Tahap 3** sebelum menghapus kolom legacy untuk memastikan tidak ada kehilangan data. Terakhir, kebijakan keamanan (RLS) diaktifkan pada **Tahap 4** untuk mengunci akses data.
