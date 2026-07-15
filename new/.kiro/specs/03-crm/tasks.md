# Tasks Specification: Customer Relationship Management (crm)

## 1. Overview
Rencana pengerjaan ini mendokumentasikan langkah-langkah implementasi data pelanggan (cabang-level) dan supplier (bisnis-level) secara incremental. Alur kerja difokuskan pada pembersihan tipe data lama, pembuatan tabel supplier, serta proteksi ketat lewat RLS di Supabase.

## 2. Task List

### Tahap 1: Modifikasi dan Penyesuaian Tabel Customers
- [x] 1.1 Lepaskan constraint lama dan rename kolom store_id.
  - Hapus constraint foreign key legacy atau unique index yang menempel pada `customers.store_id` (seperti `fk_customers_store` jika ada).
  - Rename kolom `store_id` menjadi `outlet_id`.
  - _Requirements: REQ-1_
- [x] 1.2 Sesuaikan kolom audit dan konversi tipe soft-delete.
  - Rename kolom audit: `createdat` -> `created_at`, `createdby` -> `created_by`, `updatedat` -> `updated_at`, `updatedby` -> `updated_by`.
  - Tambahkan kolom `uuid` (UUID) default `gen_random_uuid()` unique, dan kolom `deleted_at` TIMESTAMPTZ.
  - Pindahkan data status `deleted = true` ke `deleted_at = NOW()`, lalu hapus kolom `deleted` (boolean).
  - _Requirements: REQ-1_
- [x] 1.3 Perbarui tipe data kolom numerik dan pasang constraints.
  - Ubah tipe data `loyalty_points` ke `DECIMAL(15,2)`.
  - Ubah tipe data `credit_limit` ke `DECIMAL(15,2)`.
  - Tambahkan UNIQUE constraint `(outlet_id, phone)`.
  - Tambahkan Foreign Key constraint `outlet_id` REFERENCES `outlets(id)` ON DELETE RESTRICT.
  - _Requirements: REQ-1_

### Tahap 2: Pembuatan Tabel Suppliers Baru
- [x] 2.1 Buat tabel `suppliers`.
  - Implementasikan skema `suppliers` (id, uuid, business_id, name, phone, email, address, tax_id, payment_terms, audit standar).
  - Tambahkan Unique constraint `(business_id, name)`.
  - Aktifkan RLS pada tabel `suppliers`.
  - _Requirements: REQ-2_

### Tahap 3: Konfigurasi Kebijakan RLS (Row Level Security)
- [x] 3.1 Pasang RLS policies pada tabel `customers`.
  - Aktifkan RLS dengan `ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;` (jika belum aktif).
  - Buat policy SELECT/INSERT/UPDATE/DELETE berbasis `public.user_has_outlet_access(outlet_id)`.
  - _Requirements: REQ-3_
- [x] 3.2 Pasang RLS policies pada tabel `suppliers`.
  - Buat policy SELECT/INSERT/UPDATE/DELETE berbasis `business_id = public.get_auth_business_id()`.
  - _Requirements: REQ-3_

## 3. Quality Gates
- [ ] Tabel `customers` termodifikasi dengan tipe data DECIMAL dan kolom audit snake_case.
- [ ] Tabel `suppliers` terbuat dengan RLS aktif.
- [ ] RLS policies membatasi data customer per-outlet dan supplier per-bisnis secara aman.
- [ ] Kueri CRUD pada customer dan supplier berjalan tanpa error pada schema database yang diperbarui.
